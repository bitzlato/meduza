module Daemons
  # Берёт все не обработанные транзакции из blockchain_tx
  # Собирает по ним входящие адреса
  # Проверяет эти адреса через valega и отмечает в базе
  #
  class IncomeTransactionsAnalyser < Base
    SLEEP_INTERVAL = 10 # seconds
    BATCH_SIZE = 100

    def process
      Rails.logger.info('Start process')
      TransactionSource.find_each do |_ts|
        BlockchainTx
          .where('id > ?', tx.last_processed_blockchain_tx_id)
          .order(:id)
          .find_in_batches(batch_size: BATCH_SIZE) do |batch|
          batch.each do |btx|
            Rails.logger.info("Process #{btx.txid}")
            TransactionChecker.new.check! btx.txid
            tx.update! last_processed_blockchain_tx_id: btx.id
          end
        end
      end
      Rails.logger.info("Sleep for #{SLEEP_INTERVAL}")
      sleep SLEEP_INTERVAL
    end
  end
end
