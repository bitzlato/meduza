# frozen_string_literal: true

module AMQP
  class TransactionChecker < Base
    def process(payload, metadata)
      Rails.logger.info "TransactionChecker payload=#{payload}, metadata=#{metadata}"
      PendingAnalysis.
        create!(
                transaction_address: payload.fetch('txid'),
                cc_code:             payload.fetch('cc_code'),
                is_address:          false,
                source:              'amqp',
                routing_key:         metadata.fetch('routing_key'),
                correlation_id:      metadata.fetch('correlation_id'),
               )
    rescue StandardError => e
      report_exception e, true, payload: payload

      raise e if is_db_connection_error?(e)
    end
  end
end
