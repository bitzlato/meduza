# frozen_string_literal: true

module AMQP
  class TransactionPender < Base
    def process(payload, metadata)
      Rails.logger.info "[TransactionChecker] payload=#{payload}, metadata=#{metadata}"
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
        attrs = {
          meta:                payload.fetch('meta', {}),
          type:                payload.fetch('type', :transaction),
          reply_to:            metadata.reply_to,
          correlation_id:      metadata.correlation_id,
        }
        pa = PendingAnalysis.
          create_with(attrs).
          find_or_create_by!(
            address_transaction: payload.fetch('txid'),
            cc_code:             payload.fetch('cc_code'),
            source:              payload.fetch('source'),
            status:              :pending,
        )
        finded_attrs = pa.attributes.slice(*attrs.keys.map(&:to_s))
        diff = HashDiff::Comparison.new( attrs, finded_attrs ).diff
        report_exception 'WTF', true, { attr: attrs, finded_attrs: finded_attrs, diff: diff } if diff.present?
      end
    end
  end
end
