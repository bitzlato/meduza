require 'bitzlato_api'

module Daemons
  class WithdrawalChecker < Base
    @sleep_time = 2.seconds

    def process
      logger.tagged('WithdrawChecker') do
        logger.info { 'Start checking..' }
        Withdrawal.aml.where(meduza_status: nil).find_each do |withdrawal|
          logger.tagged("Check withdrawal(#{withdrawal.id}) to address #{withdrawal.address}") do

            withdrawal.with_lock do
              if withdrawal.currency.skip?
                withdrawal.pending! aml_skipped_at: Time.zone.now
                next
              end
              payload = {
                address: withdrawal.address,
                cc_code: withdrawal.cc_code,
                source:  'p2p',
                meta: { withdrawal_id: withdrawal.id, sent_at: Time.zone.now.iso8601 }
              }
              AMQP::Queue.publish :meduza, payload,
                correlation_id: withdrawal.id,
                routing_key: AMQP::Config.binding(:address_pender).fetch(:routing_key),
                reply_to: AMQP::Config.binding(:withdrawal_rpc_callback).fetch(:routing_key)

              withdrawal.update_column :meduza_status, { status: :pended, pended_at: Time.zone.now.iso8601 }
            end
          end
        end
      end
    end
  end
end
