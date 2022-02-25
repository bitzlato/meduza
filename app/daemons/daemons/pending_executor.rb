module Daemons
  # Берёт все не обработанные транзакции из pending_transactions и обрабатывает
  # Собирает по ним входящие адреса
  # Проверяет эти адреса через valega и отмечает в базе
  #
  class PendingExecutor < Base
    @sleep_time = 2.seconds

    # TODO Проверять в одной валеговской транзкции сразу все транзакции по разным валютам
    def process
      Rails.logger.info("[PendingExecutor] Start process with #{ANALYZABLE_CODES.to_a.join(',')} analyzable codes")
      ANALYZABLE_CODES.each do |cc_code|
        Rails.logger.info("Process #{cc_code}")
        pas = PendingAnalysis
          .pending
          .where(cc_code: cc_code)
          .order(:id)
          .limit(ValegaClient::MAX_ELEMENTS)

        # Докидываем на проверку старые транзакции
        unless pas.any?
          Rails.logger.info("No new pending transactions for cc_code=#{cc_code}")
          next
        end
        Rails.logger.info("Process pending transactions #{pas.pluck(:address_transaction).join(',')} for #{cc_code}")
        ValegaAnalyzer
          .new
          .analyze_transaction(pas.pluck(:address_transaction), cc_code)
          .each do |ar|

          ta = pas.find_by(cc_code: cc_code, txid: ar.txid) || TransactionAnalysis.create!(
            analysis_result: ar,
            txid: ar.txid,
            cc_code: cc_code
          )
          ta.update! analysis_result: ar
          ta.done! ar
          action = ta.risk_level == 3 ? :block : :pass
          data = { txid: ta.txid, action: action, transaction_analyses_id: ta.id }
          Rails.logger.info("Pending transaction ##{ta.id} #{ta.txid} processed with results #{ta.as_json}")
          AMQP::Queue.exchange(:transaction_checker, data, ta.meta.slice('routing_key', 'correlation_id')) if ta.present? && ta.meta.present?
        end

        break unless @running
      rescue ValegaClient::TooManyRequests => err
        report_exception err, true
        Rails.logger.error "Retry: #{err.message}"
        sleep 10
        retry
      rescue StandardError => e
        report_exception e, true, cc_code: cc_code
        sleep 10
      end
    end
  end
end
