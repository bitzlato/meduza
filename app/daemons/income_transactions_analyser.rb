module Daemons

  # Берёт все не обработанные транзакции из blockchain_tx
  # Собирает по ним входящие адреса
  # Проверяет эти адреса через valega и отмечает в базе
  #
  class IncomeTransactionsAnalyser < Base
    SLEEP_INTERVAL = 10 # seconds
    BATCH_SIZE = 100

    def process(service)
      TransactionSource.find_each do |ts|
        BlockchainTx.
          where('id > ?', tx.last_processed_blockchain_tx_id).
          order(:id).
          find_in_batches(batch_size: BATCH_SIZE) do |batch|
          batch.each do |btx|
            TransactionChecker.new.check! btx.txid
            tx.update! last_processed_blockchain_tx_id: btx.id
          end
        end
      end
      sleep SLEEP_INTERVAL
    end
  end
end
