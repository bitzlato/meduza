module AMQP
  class LegacyWithdrawalRpcCallback < Base
    def process(payload, metadata)
      logger.tagged 'LegacyWithdrawalRpcCallback' do
        logger.info "payload=#{payload}, metadata=#{metadata}"
        action = payload['action']
        withdrawal = Withdrawal.find metadata.correlation_id
        withdrawal.with_lock do
          withdrawal.update_columns meduza_status: { status: :checked, action: action } if withdrawal.meduza_status.nil?
        end
      end
    rescue ActiveRecord::RecordNotFound => err
      report_exception err, true, { payload: payload, metadata: metadata }
    end
  end
end
