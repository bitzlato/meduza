module Daemons
  # Берёт все не обработанные транзакции из pending_transactions и обрабатывает
  # Собирает по ним входящие адреса
  # Проверяет эти адреса через valega и отмечает в базе
  #
  class PendingExecutor < Base
    LIMIT = 100

    @sleep_time = 2.seconds

    # TODO Проверять в одной валеговской транзкции сразу все транзакции по разным валютам
    def process
      Rails.logger.info("[PendingExecutor] Start process with #{ANALYZABLE_CODES.to_a.join(',')} analyzable codes")
       PendingAnalysis.group(:cc_code).count.keys.each do |cc_code|
        Rails.logger.debug("Process #{cc_code}")
        pending_analises = PendingAnalysis
          .pending
          .where(cc_code: cc_code)
          .order(:id)
          .limit(LIMIT)

        # Докидываем на проверку старые транзакции
        unless pending_analises.any?
          Rails.logger.debug("No new pending transactions for cc_code=#{cc_code}")
          next
        end
        Rails.logger.info("[PendingExecutor] Process pending transactions #{pending_analises.pluck(:address_transaction).join(',')} for #{cc_code}")
        pending_analises_for_valega = pending_analises.reject do |pending_analisis|
          transaction_analysis = TransactionAnalysis.find_by(cc_code: pending_analisis.cc_code, txid: pending_analisis.address_transaction)
          if transaction_analysis.present? && transaction_analysis.analysis_result.present?
            Rails.logger.info("[PendingExecutor] Push saved transaction_analysis #{transaction_analysis.as_json}")
            pending_analisis.update! analysis_result: transaction_analysis.analysis_result
            rpc_callback pending_analisis if pending_analisis.callback?
            pending_analisis.done!
          else
            false
          end
        end
        pending_analises_for_valega.each_slice(ValegaClient::MAX_ELEMENTS) do |sliced|
          ValegaAnalyzer
            .new
            .analyze_transaction(sliced.map(&:address_transaction), cc_code)
            .each do |analysis_result|

            pending_analisis = pending_analises.find_by cc_code: cc_code, address_transaction: analysis_result.address_transaction

            pending_analisis.with_lock do
              if analysis_result.transaction?
                transaction_analysis = TransactionAnalysis
                  .create_with(analysis_result: analysis_result)
                  .find_or_create_by!(
                    txid: analysis_result.address_transaction,
                    cc_code: cc_code
                )
                transaction_analysis.update! analysis_result: analysis_result unless transaction_analysis.analysis_result == analysis_result
                pending_analisis.update! analysis_result: analysis_result
                rpc_callback pending_analisis if pending_analisis.callback?
                pending_analisis.done!

                # TODO analysis_result.address? создавать AddressAnalysis
              else
                raise "not supported #{analysis_result}"
              end
            end
          end
        end

        break unless @running
      rescue ValegaClient::TooManyRequests => err
        report_exception err, true
        Rails.logger.error "[PendingExecutor] Retry: #{err.message}"
        sleep 10
        retry
      rescue StandardError => e
        report_exception e, true, cc_code: cc_code
        sleep 10
      end
    end

    def rpc_callback(pending_analisis)
      analysis_result = pending_analisis.analysis_result
      action = analysis_result.risk_level == 3 ? :block : :pass
      payload = { address_transaction: pending_analisis.address_transaction, cc_code: pending_analisis.cc_code, action: action, analysis_result_id: analysis_result.id }
      properties = { correlation_id: pending_analisis.correlation_id, routing_key: pending_analisis.reply_to }
      Rails.logger.info "[PendingExecutor] rpc_callback with payload #{payload} and properties #{properties}"
      AMQP::Queue.publish :meduza, payload, properties
    end
  end
end
