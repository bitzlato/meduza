# frozen_string_literal: true

module AMQP
  class TransactionPender < Base
    def process(payload, metadata)
      Rails.logger.info "[TransactionPender] payload=#{payload}, metadata=#{metadata}"
      ta = TransactionAnalysis.find_by(txid: payload.fetch('txid'), cc_code: payload.fetch('cc_code'))
      if ta.present?
        payload = {
          address_transaction: ta.address_transaction,
          cc_code: ta.cc_code,
          action: ValegaAnalyzer.pass?(ta.analysis_result.risk_level) ? :pass : :block,
          analysis_result_id: ta.analysis_result_id,
          from: :TransactionPender
        }
        payload.merge! transaction_analysis_id: transaction_analysis.id if transaction_analysis.present?
        properties = { correlation_id: pending_analisis.correlation_id, routing_key: pending_analisis.reply_to }
        Rails.logger.info "[TransactionPender] rpc_callback with payload #{payload} and properties #{properties}"
        AMQP::Queue.publish :meduza, payload, properties
      else
        attrs = {
          meta:                payload.fetch('meta', {}),
          type:                payload.fetch('type', :transaction),
          reply_to:            metadata.reply_to,
          correlation_id:      metadata.correlation_id,
        }
        begin
          Rails.logger.info "[TransactionPender] find_or_create PendingAnalysis with payload #{payload} and attrs #{attrs}"
          pa = PendingAnalysis.
            create_with(attrs).
            find_or_create_by!(
              address_transaction: payload.fetch('txid'),
              cc_code:             payload.fetch('cc_code'),
              source:              payload.fetch('source'),
              state:              :pending,
          )
          finded_attrs = pa.attributes.slice(*attrs.keys.map(&:to_s))
          diff = HashDiff::Comparison.new( attrs, finded_attrs.symbolize_keys ).diff
          report_exception 'WTF', true, { pending_analisis_id: pa.id, attr: attrs, finded_attrs: finded_attrs, diff: diff } if diff.present?
        rescue ActiveRecord::RecordInvalid => err
          Rails.logger.info "[TransactionPender] PendingAnalysis already exists #{payload} with error #{err}"
        end
      end
    end
  end
end
