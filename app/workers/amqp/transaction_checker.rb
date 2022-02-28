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
                reply_to:            metadata.reply_to,
                correlation_id:      metadata.correlation_id,
                type:                :transaction
               )
    end
  end
end
