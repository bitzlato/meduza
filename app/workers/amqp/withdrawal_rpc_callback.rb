module AMQP
  class WithdrawalRpcCallback < Base
    def process(payload, metadata)
      logger.tagged 'WithdrawalRpcCallback' do
        logger.info "payload=#{payload}, metadata=#{metadata}"

        withdrawal = Withdrawal.find metadata.correlation_id

        action = payload['action']
        if payload['action'] == 'pass'
          logger.info("Pass withdrawal #{withdrawal.id}")
          withdrawal.pending!({ status: :checked, action: action })
        else
          withdrawal.update_columns meduza_status: { status: :checked, action: action }
          logger.info("Block withdrawal #{withdrawal.id}")
          freeze_user!(withdrawal)
        end
      end
    rescue ActiveRecord::RecordNotFound => err
      report_exception err, true, { payload: payload, metadata: metadata }
    end

    private

    def freeze_user!(withdrawal)
      params = {
        expire: 1.year.from_now.to_i,
        reason: "Грязный вывод ##{withdrawal.id} на адресс #{withdrawal.address}",
        type: 'all',
        unfreeze: false
      }
      response = BitzlatoAPI.new.freeze_user(withdrawal.user_id, params: params)

      if response.success?
        logger.info { "User ##{withdrawal.user_id} has been freezed" }
      else
        logger.info { "User ##{withdrawal.user_id} has not been freezed because P2P is not available" }
        raise "Wrong response status (#{response.status}) with body #{response.body}"
      end
    end
  end
end
