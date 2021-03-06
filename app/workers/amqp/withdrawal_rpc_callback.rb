module AMQP
  class WithdrawalRpcCallback < Base
    FREEZE_EXPIRE = 100.years

    # Принимает результаты проверки от WithdrawalChecker
    def process(payload, metadata)
      logger.info "payload=#{payload}, metadata=#{metadata}"

      withdrawal = Withdrawal.find metadata.correlation_id

      action = payload['action']
      if action == 'pass'
        begin
          logger.info("Pass withdrawal #{withdrawal.id}")
          withdrawal.pending!({ status: :checked, action: action })
        rescue Withdrawal::WrongStatus => err
          report_exception err, true, { payload: payload, metadata: metadata }
        end
      else
        logger.info("Block withdrawal #{withdrawal.id}")
        withdrawal.update_columns meduza_status: { status: :checked, action: action }
        freeze_user!(withdrawal)
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
      withdrawal.update_columns meduza_status: withdrawal.meduza_status.merge(freezed_at: Time.zone.now.iso8601)
    end
  end
end
