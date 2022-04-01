
module Daemons
  # Legacy
  # Берёт все не обработанные транзакции из P2P blockchain_tx и засовывает в pending_transactions
  class LegacyPender < Base
    @sleep_time = 1.seconds
    LIMIT = 10
    MAX_PENDING_QUEUE_SIZE = 5
    CHECK_START_DATE = Date.parse('01-10-2021')

    # TODO Проверять в одной валеговской транзкции сразу все транзакции по разным валютам
    def process
      AML_ANALYZABLE_CODES.each do |cc_code|
        scope = BlockchainTx
          .where('created_at>=?', CHECK_START_DATE)
          .where(meduza_status: nil)
          .where(cc_code: cc_code)
        Rails.logger.info("[LegacyPender] Select #{cc_code} count is #{scope.count}")
        btx_count = scope
          .order(:id)
          .limit(LIMIT)
          .each do |btx|
          next if PendingAnalysis.pending.where(cc_code: cc_code).count > MAX_PENDING_QUEUE_SIZE
          if PendingAnalysis.pending.exists?(address_transaction: btx.txid, cc_code: btx.cc_code)
            Rails.logger.info("[LegacyPender] PendingAnalysis already exists #{btx.txid}")
            return
          end

          ta = TransactionAnalysis.find_by(txid: btx.txid, cc_code: btx.cc_code)
          if ta.present?
            Rails.logger.info("[LegacyPender] TransactionAnalysis already exists #{btx.txid} update blockhain_tx")
            ta.update_blockchain_tx_status
          else
            Rails.logger.info("[LegacyPender] Put pending analysis #{btx.id}: #{btx.txid} #{cc_code}")
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
            btx.update! meduza_status: { status: :pended }
          end
        end.count
        Rails.logger.debug("[LegacyPender] #{btx_count} processed for #{cc_code}")
        break unless @running
      end
    end
  end
end
