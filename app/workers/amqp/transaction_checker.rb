# frozen_string_literal: true

module AMQP
  class TransactionChecker < Base
    def process(payload, metadata)
      Rails.logger.info "TransactionChecker payload=#{payload}, metadata=#{metadata}"
      PendingAnalysis.
        create!(
                transaction_address: payload.fetch('txid'),
                cc_code:             payload.fetch('cc_code'),
                source:              payload.fetch('source'),
                meta:                payload.fetch('meta', {}),
                routing_key:         metadata.routing_key,
                correlation_id:      metadata.correlation_id,
                type:                :transaction
               )
    rescue StandardError => e
      report_exception e, true, payload: payload

      raise e if is_db_connection_error?(e)
    end
  end
end
