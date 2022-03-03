
module Daemons
  # Legacy
  # Берёт все не обработанные транзакции из P2P blockchain_tx и засовывает в pending_transactions
  class LegacyPender < Base
    @sleep_time = 1.seconds
    LIMIT = 20

    attr_reader :reply_queue

    # TODO Проверять в одной валеговской транзкции сразу все транзакции по разным валютам
    def process
      AML_ANALYZABLE_CODES.each do |cc_code|
        transaction_source = TransactionSource.find_or_create_by!(cc_code: cc_code)
        transaction_source.reload
        Rails.logger.debug("[LegacyPender] Select #{cc_code} from #{transaction_source.last_processed_blockchain_tx_id}")
        btx_count = BlockchainTx
          .receive
          .where('id > ?', transaction_source.last_processed_blockchain_tx_id)
          .where(cc_code: cc_code)
          .order(:id)
          .limit(LIMIT)
          .each do |btx|
            Rails.logger.info("[LegacyPender] Put pending analysis #{btx.id}: #{btx.txid} #{cc_code}")
            payload = {
              txid:    btx.txid,
              cc_code: btx.cc_code,
              source:  'p2p',
              meta: { blockchain_tx_id: btx.id }
            }
            AMQP::Queue.publish :meduza, payload,
              correlation_id: btx.id,
              routing_key: AMQP::Config.binding(:transaction_pender).fetch(:routing_key),
              reply_to: AMQP::Config.binding(:legacy_rpc_callback).fetch(:routing_key)
            transaction_source.update! last_processed_blockchain_tx_id: btx.id if btx.id > transaction_source.last_processed_blockchain_tx_id
          end.count
        Rails.logger.debug("[LegacyPender] #{btx_count} processed for #{cc_code}")
        break unless @running
      end
    end

    private

    def setup_reply_queue
      bunny_conn = Bunny.new AMQP::Config.connect
      bunny_conn.start
      channel = bunny_conn.create_channel
      @reply_queue = channel.queue('', exclusive: true)
      @reply_queue.subscribe do |_delivery_info, properties, payload|
        Rails.logger.info "[LegacyPender] Receive reply_to with payload #{payload} and properties #{properties}"
      end
    end
  end
end
