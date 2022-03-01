# frozen_string_literal: true

module AMQP
  class TransactionChecker < Base
    def process(payload, metadata)
      Rails.logger.info "[TransactionChecker] payload=#{payload}, metadata=#{metadata}"
      if PendingAnalysis.find_by(
        address_transaction: payload.fetch('txid'),
        cc_code:             payload.fetch('cc_code'),
        source:              payload.fetch('source'),
      ).present?
        Rails.logger.debug("Skip #{payload}")
      end
      PendingAnalysis.
        create!(
                address_transaction: payload.fetch('txid'),
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
