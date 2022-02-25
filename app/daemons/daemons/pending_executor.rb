module Daemons
  # Берёт все не обработанные транзакции из pending_transactions и обрабатывает
  # Собирает по ним входящие адреса
  # Проверяет эти адреса через valega и отмечает в базе
  #
  class PendingExecutor < Base
    @sleep_time = 2.seconds

    # TODO Проверять в одной валеговской транзкции сразу все транзакции по разным валютам
    def process
      Rails.logger.info("Start process with #{ANALYZABLE_CODES.to_a.join(',')} analyzable codes")
      ANALYZABLE_CODES.each do |cc_code|
        Rails.logger.info("Process #{cc_code}")
        tas = TransactionAnalysis
          .pending
          .where(cc_code: cc_code)
          .order(:id)
          .limit(ValegaClient::MAX_ELEMENTS)

        # Докидываем на проверку старые транзакции
        unless tas.any?
          Rails.logger.info("No new pending transactions for cc_code=#{cc_code}")
          next
        end
        Rails.logger.info("Process pending transactions #{tas.pluck(:txid).join(',')} for #{cc_code}")
        ValegaAnalyzer
          .new
          .analyze_transaction(tas.pluck(:txid), cc_code)
          .each do |ta|

          pt = tas.find_by(ta.txid)
          pt.update! status: :checked
          action = ta.risk_level == 3 ? :block : :pass
          data = { txid: pt.txid, action: action, transaction_analyses_id: ta.id }
          Rails.logger.info("Pending transaction ##{pt.id} #{pt.txid} processed with results #{ta.as_json}")
          exchange.publish(
            data,
            routing_key: pt.metadata.reply_to,
            correlation_id: pt.metadata.correlation_id
          ) if pt.metadata.present?
        end

        break unless @running
      rescue ValegaClient::TooManyRequests => err
        report_exception err, true
        Rails.logger.error "Retry: #{err.message}"
        sleep 1
        retry
      rescue StandardError => e
        report_exception e, true, cc_code: cc_code
      end
    end
  end
end
