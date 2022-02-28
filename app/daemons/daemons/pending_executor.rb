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
        pending_analises = PendingAnalysis
          .pending
          .where(cc_code: cc_code)
          .order(:id)
          .limit(ValegaClient::MAX_ELEMENTS)

        # Докидываем на проверку старые транзакции
        unless pending_analises.any?
          Rails.logger.info("No new pending transactions for cc_code=#{cc_code}")
          next
        end
        Rails.logger.info("Process pending transactions #{pending_analises.pluck(:address_transaction).join(',')} for #{cc_code}")
        ValegaAnalyzer
          .new
          .analyze_transaction(pending_analises.pluck(:address_transaction), cc_code)
          .each do |analysis_result|

          pending_analisis = pending_analises.find_by cc_code: cc_code, address_transaction: analysis_result.address_transaction

          pending_analisis.with_lock do
            if analysis_result.transaction?
              TransactionAnalysis.find_or_create_by!(
                txid: analysis_result.address_transaction,
                cc_code: cc_code
              )
              ta.update! analysis_result: analysis_result
              pending_analises.update! analysis_result: analysis_result
              pending_analisis.done!

              rpc_callback pending_analisis if pending_analisis.callback?
            else
              raise "not supported #{analysis_result}"
            end
          end
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

    def rpc_callback(pending_analisis)
      analysis_result = pending_analisis
      action = analysis_result.risk_level == 3 ? :block : :pass
      data = { address_transaction: pending_analisis.address_transaction, action: action, analysis_result_id: analysis_result.id }

      AMQP::Queue.exchange(:transaction_checker, data, pending_analisis.attributes.slice('routing_key', 'correlation_id'))
    end
  end
end
