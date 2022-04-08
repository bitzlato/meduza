module AMQP
  class WithdrawalRpcCallback < Base
    FREEZE_EXPIRE = 100.years

    def process(payload, metadata)
      logger.tagged 'WithdrawalRpcCallback' do
        logger.info "payload=#{payload}, metadata=#{metadata}"

        withdrawal = Withdrawal.find metadata.correlation_id

        action = payload['action']
        if payload['action'] == 'pass'
          begin
            logger.info("Pass withdrawal #{withdrawal.id}")
            withdrawal.pending!({ status: :checked, action: action })
          rescue Withdrawal::WrongStatus => err
            report_exception err, true, { payload: payload, metadata: metadata }
          end
        else
          withdrawal.update_columns meduza_status: { status: :checked, action: action }
          logger.info("Block withdrawal #{withdrawal.id}")
          # Отключили пока
          freeze_user!(withdrawal)
          withdrawal.update_columns meduza_status: withdrawal.meduza_status.merge(freezed: Time.zone.now.to_i)
        end
      end
    rescue ActiveRecord::RecordNotFound => err
      report_exception err, true, { payload: payload, metadata: metadata }
    end

    private

    def freeze_user!(withdrawal)
      params = {
        expire: FREEZE_EXPIRE.from_now.to_i,
        reason: "Грязный вывод ##{withdrawal.id} на адрес #{withdrawal.address}",
        type: 'all',
        unfreeze: false
      }
      response = BitzlatoAPI.new.freeze_user(withdrawal.user_id, params)

      if response.success?
        logger.info { "User ##{withdrawal.user_id} has been freezed" }
      else
        logger.info { "User ##{withdrawal.user_id} has not been freezed because P2P is not available" }
        raise "Wrong response status (#{response.status}) with body #{response.body}"
      end
    end
  end
end
