module AMQP
  class LegacyRpcCallback
    #payload = {
      #address_transaction: pending_analisis.address_transaction,
      #cc_code: pending_analisis.cc_code,
      #action: action,
      #analysis_result_id: analysis_result.try(:id),
      #pending_analisis_state: pending_analisis.state
    #}
    #payload.merge! transaction_analysis_id: transaction_analysis.id if transaction_analysis.present?
    def process(payload, metadata)
      Rails.logger.info "[LegacyRpcCallback] payload=#{payload}, metadata=#{metadata}"
      ta_id = payload.symbolize_keys.dig(:transaction_analysis_id)
      if ta_id.present?
        transaction_analysis = TransactionAnalysis.find ta_id
        Rails.logger.info "[LegacyRpcCallback] update_blockchain_tx_status for ta_id #{ta_id} #{transaction_analysis.txid}"
        transaction_analysis.update_blockchain_tx_status
      end
    end
  end
end
