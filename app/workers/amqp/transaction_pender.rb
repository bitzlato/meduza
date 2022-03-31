# frozen_string_literal: true

module AMQP
  class TransactionPender < Base
    def process(payload, metadata)
      Rails.logger.info "[TransactionChecker] payload=#{payload}, metadata=#{metadata}"
      if PendingAnalysis.pending.find_by(
        address_transaction: payload.fetch('txid'),
        cc_code:             payload.fetch('cc_code'),
        source:              payload.fetch('source'),
      ).present?
        # TODO отвечать сразу если есть
        Rails.logger.info("[TransactionChecker] Skip #{payload}")
        payload = {
          address_transaction: payload.fetch('txid'),
          cc_code: payload.fetch('cc_code'),
          action: :queued
        }
        properties = { routing_key: metadata.reply_to, correlation_id:  metadata.correlation_id }
        Rails.logger.info "[TransactionAnalysis] rpc_callback with payload #{payload} and properties #{properties}"
        AMQP::Queue.publish :meduza, payload, properties
        return
      end
      ta = TransactionAnalysis.find_by(txid: payload.fetch('txid'), cc_code: payload.fetch('cc_code'))
      if ta.present?
        payload = {
          address_transaction: ta.address_transaction,
          cc_code: ta.cc_code,
          action: ValegaAnalyzer.pass?(ta.analysis_result.risk_level) ? :pass : :block,
          analysis_result_id: ta.analysis_result_id
        }
        payload.merge! transaction_analysis_id: transaction_analysis.id if transaction_analysis.present?
        properties = { correlation_id: pending_analisis.correlation_id, routing_key: pending_analisis.reply_to }
        Rails.logger.info "[TransactionAnalysis] rpc_callback with payload #{payload} and properties #{properties}"
        AMQP::Queue.publish :meduza, payload, properties
      else
        PendingAnalysis.
          create!(
            address_transaction: payload.fetch('txid'),
            cc_code:             payload.fetch('cc_code'),
            source:              payload.fetch('source'),
            meta:                payload.fetch('meta', {}),
            type:                payload.fetch('type', :transaction),
            reply_to:            metadata.reply_to,
            correlation_id:      metadata.correlation_id,
        )
      end
    end
  end
end
