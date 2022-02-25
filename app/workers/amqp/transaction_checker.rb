# frozen_string_literal: true

module Workers
  module AMQP
    class TransactionChecker < Base
      def process(payload)
        # todo
      rescue StandardError => e
        report_exception e, true, payload: payload

        raise e if is_db_connection_error?(e)
      end
    end
  end
end
