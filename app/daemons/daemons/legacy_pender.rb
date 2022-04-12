
module Daemons
  # Legacy
  # Берёт все не обработанные транзакции из P2P blockchain_tx и засовывает в pending_transactions
  class LegacyPender < Base
    @sleep_time = 1.seconds
    LIMIT = 10
    MAX_PENDING_QUEUE_SIZE = ValegaClient::MAX_ELEMENTS
    CHECK_START_DATE = Date.parse('01-01-2022')

    SKIP_AML = false

    def process
      logger.tagged('LegacyPender') do
        # process_transactions
        return unless @running
        process_withdrawals
      end
    end

    def process_withdrawals
      logger.tagged 'process_withdrawals' do
      AML_ANALYZABLE_CODES.each do |cc_code|
        scope = Withdrawal
          .where('created_at>=?', CHECK_START_DATE)
          .where(meduza_status: nil)
          .where.not(status: :aml)
          .where(cc_code: cc_code)
        logger.info("Select #{cc_code} count is #{scope.count}")
        withdraws_count = scope
          .order(:id)
          .limit(LIMIT)
          .each do |withdrawal|
          if SKIP_AML
            withdrawal.pending! aml_skipped_at: Time.zone.now
            next
          end
          next if PendingAnalysis.pending.where(cc_code: cc_code).count > MAX_PENDING_QUEUE_SIZE
          if PendingAnalysis.pending.exists?(address_transaction: withdrawal.address, cc_code: withdrawal.cc_code)
            logger.info("PendingAnalysis already exists #{withdrawal.address}")
            return
          end

          aa = AddressAnalysis.find_by(address: withdrawal.address, cc_code: withdrawal.cc_code)
          if aa.present?
            action = aa.analysis_result.pass? ? :pass : :block
            logger.info("AddressAnalysis already exists #{withdrawal.address} update blockhain_tx")
            withdrawal.with_lock do
              withdrawal.update_columns meduza_status: (withdrawal.meduza_status || {}).merge( status: :checked, action: action )
            end
          else
            logger.info("Put pending analysis #{withdrawal.id}: #{withdrawal.address} #{cc_code}")

            withdrawal.with_lock do
              payload = {
                address: withdrawal.address,
                cc_code: withdrawal.cc_code,
                source:  'legacy_pender',
                meta: { withdrawal_id: withdrawal.id, sent_at: Time.zone.now }
              }
              AMQP::Queue.publish :meduza, payload,
                correlation_id: withdrawal.id,
                routing_key: AMQP::Config.binding(:address_pender).fetch(:routing_key),
                reply_to: AMQP::Config.binding(:legacy_withdrawal_rpc_callback).fetch(:routing_key)

              withdrawal.update_column :meduza_status, { status: :pended, pended_at: Time.zone.now.iso8601 }
            end
          end
        end.count
        logger.debug("#{withdraws_count} processed for #{cc_code}")
        break unless @running
      end
      end
    end

    def process_transactions
      logger.tagged 'process_transactions' do
        AML_ANALYZABLE_CODES.each do |cc_code|
          scope = BlockchainTx
            .where('created_at>=?', CHECK_START_DATE)
            .where(meduza_status: nil)
            .where(cc_code: cc_code)
          logger.info("Select #{cc_code} count is #{scope.count}")
          btx_count = scope
            .order(:id)
            .limit(LIMIT)
            .each do |btx|
            next if PendingAnalysis.pending.where(cc_code: cc_code).count > MAX_PENDING_QUEUE_SIZE
            if PendingAnalysis.pending.exists?(address_transaction: btx.txid, cc_code: btx.cc_code)
              logger.info("PendingAnalysis already exists #{btx.txid}")
              return
            end

            ta = TransactionAnalysis.find_by(txid: btx.txid, cc_code: btx.cc_code)
            if ta.present?
              logger.info("TransactionAnalysis already exists #{btx.txid} update blockhain_tx")
              ta.update_blockchain_tx_status
            else
              logger.info("Put pending analysis #{btx.id}: #{btx.txid} #{cc_code}")
              payload = {
                txid:    btx.txid,
                cc_code: btx.cc_code,
                source:  'p2p',
                meta: { blockchain_tx_id: btx.id, sent_at: Time.zone.now }
              }
              AMQP::Queue.publish :meduza, payload,
                correlation_id: btx.id,
                routing_key: AMQP::Config.binding(:transaction_pender).fetch(:routing_key),
                reply_to: AMQP::Config.binding(:legacy_rpc_callback).fetch(:routing_key)
              btx.update! meduza_status: { status: :pended, pended_at: Time.zone.now.iso8601 }
            end
          end.count
          Rails.logger.debug("[LegacyPender] #{btx_count} processed for #{cc_code}")
          break unless @running
        end
      end
    end
  end
end
