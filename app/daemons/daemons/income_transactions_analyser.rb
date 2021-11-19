module Daemons
  # Берёт все не обработанные транзакции из blockchain_tx
  # Собирает по ним входящие адреса
  # Проверяет эти адреса через valega и отмечает в базе
  #
  class IncomeTransactionsAnalyser < Base
    SLEEP_INTERVAL = 10 # seconds
    BATCH_SIZE = 100

    # CC_CODES = ["REEF", "BCD", "SONO", "ETC", "BTG", "DAI", "DOGE", "MDT", "BEAM", "DASH", "PIVX", "BTC", "USDC", "USDT", "LTC", "MCR", "USDM", "RUBM", "BCH", "ETH"]
    CC_CODES = %w[BTC]

    def self.scope
      BlockchainTx
        .where("source ->> 'category' = 'receive'")
        .where(cc_code: CC_CODES)
    end

    def process
      Rails.logger.info('Start process')
      TransactionSource.find_each do |transaction_source|
          self.class.scope
          .where('id > ?', transaction_source.last_processed_blockchain_tx_id)
          .find_in_batches(batch_size: BATCH_SIZE) do |batch|
          batch.each do |btx|
            Rails.logger.info("Process id=#{btx.id} txid=#{btx.txid}")
            TransactionChecker.new.check! btx.txid, btx.cc_code
            transaction_source.update! last_processed_blockchain_tx_id: btx.id
          end
        end
      end
      Rails.logger.info("Sleep for #{SLEEP_INTERVAL}")
      sleep SLEEP_INTERVAL
    rescue => err
      report_exception err
    end
  end
end
