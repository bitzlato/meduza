
module Daemons
  # Legacy
  # Берёт все не обработанные транзакции из P2P blockchain_tx и засовывает в pending_transactions
  class LegacyPender < Base
    @sleep_time = 1.seconds
    LIMIT = 20

    # TODO Проверять в одной валеговской транзкции сразу все транзакции по разным валютам
    def process
      Rails.logger.info("[LegacyPender] Start process with #{ANALYZABLE_CODES.to_a.join(',')} analyzable codes")
      count = ANALYZABLE_CODES.each do |cc_code|
        transaction_source = TransactionSource.find_or_create_by!(cc_code: cc_code)
        transaction_source.reload
        BlockchainTx
          .receive
          .where('id > ?', transaction_source.last_processed_blockchain_tx_id)
          .where(cc_code: cc_code)
          .order(:id)
          .limit(LIMIT)
          .each do |btx|
            Rails.logger.info("Put to penging_transaction #{btx.id}: #{btx.txid} #{cc_code}")
            payload = {
              txid:    btx.txid,
              cc_code: btx.cc_code,
              source:  'p2p'
            }
            properties = {
              reply_to:       'meduza.p2p.rpc_callback',
              correlation_id: btx.id
            }
            AMQP::Queue.exchange(:meduza, payload, properties)
            # PendingAnalysis.create! address_transaction: btx.txid, cc_code: btx.cc_code, type: :transaction, source: 'p2p' unless PendingAnalysis.find_by(address_transaction: btx.txid).present?
            transaction_source.update! last_processed_blockchain_tx_id: btx.id if btx.id > transaction_source.last_processed_blockchain_tx_id
          end.count
        Rails.logger.info("[LegacyPender] #{count} processed")
        break unless @running
      end
    end
  end
end
