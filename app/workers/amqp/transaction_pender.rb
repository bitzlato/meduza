# frozen_string_literal: true

module AMQP
  class TransactionPender < Base
    def process(payload, metadata)
      logger.info "process payload=#{payload}, metadata=#{metadata}"
      ta = TransactionAnalysis.find_by(txid: payload.fetch('txid'), cc_code: payload.fetch('cc_code'))
      if ta.present?
        payload = {
          address_transaction: ta.txid,
          cc_code: ta.cc_code,
          action: ta.analysis_result.pass? ? :pass : :block,
          analysis_result_id: ta.analysis_result_id,
          from: :TransactionPender
        }
        payload.merge! transaction_analysis_id: ta.id if ta.present?
        properties = { correlation_id: metadata.correlation_id, routing_key: metadata.reply_to }
        logger.info "rpc_callback with payload #{payload} and properties #{properties}"
        AMQP::Queue.publish :meduza, payload, properties
      else
        attrs = {
          meta:                payload.fetch('meta', {}),
          type:                payload.fetch('type', :transaction),
        }
        begin
          logger.info "find_or_create PendingAnalysis with payload #{payload} and attrs #{attrs}"
          pa = PendingAnalysis.create_with(attrs).
            find_or_create_by!(
              address_transaction: payload.fetch('txid'),
              cc_code:             payload.fetch('cc_code'),
              blockchain:          lookup_blockchain(payload.fetch('blockchain')),
              source:              payload.fetch('source'),
              state:               :pending,
              reply_to:            metadata.reply_to,
              correlation_id:      metadata.correlation_id,
          )
          finded_attrs = pa.attributes.slice(*attrs.keys.map(&:to_s)).symbolize_keys
          unless finded_attrs.sort.join == attrs.sort.join
            report_exception 'Отличия в PendingAnalysis', true, { pending_analisis_id: pa.id, attr: attrs, finded_attrs: finded_attrs }
          end
        rescue ActiveRecord::RecordInvalid => err
          logger.warn "PendingAnalysis already exists #{payload} with error #{err}"
        end
      end
    rescue KeyError => e
      report_exception(e, true, { service: self.class.name })
    end
  end
end
