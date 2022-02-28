
module Daemons
  # Legacy
  # Берёт все не обработанные транзакции из P2P blockchain_tx и засовывает в pending_transactions
  class LegacyPender < Base
    @sleep_time = 1.seconds
    LIMIT = 20

    # TODO Проверять в одной валеговской транзкции сразу все транзакции по разным валютам
    def process
      ANALYZABLE_CODES.each do |cc_code|
        transaction_source = TransactionSource.find_or_create_by!(cc_code: cc_code)
        transaction_source.reload
        Rails.logger.info("[LegacyPender] Select #{cc_code} from #{transaction_source.last_processed_blockchain_tx_id}")
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
            properties = {
              reply_to:       'meduza.p2p.rpc_callback',
              correlation_id: btx.id
            }
            AMQP::Queue.enqueue(:transaction_checker, payload, properties)
            # PendingAnalysis.create! address_transaction: btx.txid, cc_code: btx.cc_code, type: :transaction, source: 'p2p' unless PendingAnalysis.find_by(address_transaction: btx.txid).present?
            transaction_source.update! last_processed_blockchain_tx_id: btx.id if btx.id > transaction_source.last_processed_blockchain_tx_id
          end.count
        Rails.logger.debug("[LegacyPender] #{btx_count} processed for #{cc_code}")
        break unless @running
      end
    end
  end
end
