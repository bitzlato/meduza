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
      Rails.logger.info("[PendingExecutor] Start process")
       PendingAnalysis.group(:cc_code).count.keys.each do |cc_code|
        Rails.logger.debug("[PendingExecutor] Process #{cc_code}")
        pending_analises = PendingAnalysis
          .pending
          .where(cc_code: cc_code)
          .order(:id)
          .limit(LIMIT)

        # Докидываем на проверку старые транзакции
        unless pending_analises.any?
          Rails.logger.debug("[PendingExecutor] No new pending transactions for cc_code=#{cc_code}")
          next
        end
        Rails.logger.info("[PendingExecutor] Process pending transactions #{pending_analises.pluck(:address_transaction).join(',')} for #{cc_code}")
        pending_analises_for_valega = check_existen pending_analises
        if AML_ANALYZABLE_CODES.include? cc_code
          Rails.logger.info("[PendingExecutor] Check pending analises in valega #{pending_analises_for_valega.pluck(:address_transaction).join(',')} for #{cc_code}")
          check_in_valega pending_analises_for_valega, pending_analises, cc_code
        else
          Rails.logger.info("[PendingExecutor] Skip pending analises #{pending_analises_for_valega.pluck(:address_transaction).join(',')} for #{cc_code}")
          skip_all pending_analises_for_valega
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

    private

    def skip_all(pending_analises)
      pending_analises.each do |pending_analisis|
        pending_analisis.skip!
        rpc_callback pending_analisis, nil, from: :skip_all if pending_analisis.callback?
      end
    end

    def check_existen(pending_analises)
      pending_analises.reject do |pending_analisis|
        transaction_analysis = TransactionAnalysis.find_by(cc_code: pending_analisis.cc_code, txid: pending_analisis.address_transaction)
        if transaction_analysis.present? && transaction_analysis.analysis_result.present?
          Rails.logger.info("[PendingExecutor] Push saved transaction_analysis #{transaction_analysis.as_json}")
          pending_analisis.update! analysis_result: transaction_analysis.analysis_result
          pending_analisis.done!
          rpc_callback pending_analisis, transaction_analysis, from: :check_existen if pending_analisis.callback?
        else
          false
        end
      end
    end

    def check_in_valega(pending_analises_for_valega, pending_analises, cc_code)
      pending_analises_for_valega.each_slice(ValegaClient::MAX_ELEMENTS) do |sliced|
        ValegaAnalyzer
          .new
          .analyze(sliced.map(&:address_transaction), cc_code)
          .each do |analysis_result|
          pending_analisis = pending_analises.find_by cc_code: cc_code, address_transaction: analysis_result.address_transaction
          if analysis_result.transaction?
            done_transaction_analisis pending_analisis, analysis_result
          elsif analysis_result.address?
            done_address_analisis pending_analisis, analysis_result
          elsif analysis_result.error?
            done_error_analysis pending_analisis, analysis_result
          else
            raise "not supported #{analysis_result}"
          end
        end
      end
    end

    def done_error_analysis(pending_analisis, analysis_result)
      pending_analisis.update! analysis_result: analysis_result
      pending_analisis.done!
      rpc_callback pending_analisis, address_analysis, from: :done_error_analisis if pending_analisis.callback?
    end

    def done_address_analisis(pending_analisis, analysis_result)
      address_analysis = AddressAnalysis
        .create_with(analysis_result: analysis_result, risk_level: analysis_result.risk_level, risk_confidence: analysis_result.risk_confidence)
        .find_or_create_by!(
          address: analysis_result.address_transaction,
          cc_code: pending_analisis.cc_code
      )
      address_analysis.update! analysis_result: analysis_result unless address_analysis.analysis_result == analysis_result
      pending_analisis.update! analysis_result: analysis_result
      pending_analisis.done!
      rpc_callback pending_analisis, address_analysis, from: :done_address_analisis if pending_analisis.callback?
    rescue ActiveRecord::RecordNotUnique => e
      retry if e.record.is_a? AddressAnalysis
    end

    def done_transaction_analisis(pending_analisis, analysis_result)
      transaction_analysis = TransactionAnalysis
        .create_with(analysis_result: analysis_result, risk_level: analysis_result.risk_level, risk_confidence: analysis_result.risk_confidence)
        .find_or_create_by!(
          txid: analysis_result.address_transaction,
          cc_code: pending_analisis.cc_code
      )
      transaction_analysis.update! analysis_result: analysis_result unless transaction_analysis.analysis_result == analysis_result
      pending_analisis.update! analysis_result: analysis_result
      pending_analisis.done!
      rpc_callback pending_analisis, transaction_analysis, from: :done_transaction_analisis if pending_analisis.callback?

      # TODO analysis_result.address? создавать AddressAnalysis
    rescue ActiveRecord::RecordNotUnique => e
      retry if e.record.is_a? TransactionAnalysis
    end

    def rpc_callback(pending_analisis, transaction_analysis = nil, extra = {})
      if pending_analisis.done?
        analysis_result = pending_analisis.analysis_result
        action = analysis_result.pass? ? :pass : :block
      elsif pending_analisis.skipped?
        action = :pass
      else
        report_exception 'Do nothing', true, pending_analisis: pending_analisis.as_json
        return
      end

      payload = {
        address_transaction: pending_analisis.address_transaction,
        cc_code: pending_analisis.cc_code,
        action: action,
        analysis_result_id: analysis_result.try(:id),
        pending_analisis_state: pending_analisis.state
      }.merge extra
      payload.merge! transaction_analysis_id: transaction_analysis.id if transaction_analysis.present?
      properties = { correlation_id: pending_analisis.correlation_id, routing_key: pending_analisis.reply_to }
      Rails.logger.info "[PendingExecutor] rpc_callback with payload #{payload} and properties #{properties}"
      AMQP::Queue.publish :meduza, payload, properties
      pending_analisis.touch :replied_at
    end
  end
end
