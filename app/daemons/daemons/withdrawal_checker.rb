require 'bitzlato_api'

module Daemons
  class WithdrawalChecker < Base
    @sleep_time = 2.seconds

    def process
      logger.tagged('[WithdrawChecker]') do
        Withdrawal.aml.find_each do |withdrawal|
          logger.tagged("Withdrawal(#{withdrawal.id}) to address #{withdrawal.address}") do
            if AddressVerifier.new(withdrawal.address, withdrawal.cc_code).pass?
              logger.info { 'Has been passed' }
              withdrawal.pending!
            else
              logger.info { 'Has not been passed' }
              freeze_user!(withdrawal)
            end
          end
        end
      end
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
