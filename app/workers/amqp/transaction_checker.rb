# frozen_string_literal: true

module AMQP
  class TransactionChecker < Base
    def process(payload, metadata)
      PendingTranscation.create! payload.slice('txid', 'cc_code').merge meta: metadata
    rescue StandardError => e
      report_exception e, true, payload: payload

      raise e if is_db_connection_error?(e)
    end
  end
end
