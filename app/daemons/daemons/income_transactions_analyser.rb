module Daemons
  # Берёт все не обработанные транзакции из blockchain_tx
  # Собирает по ним входящие адреса
  # Проверяет эти адреса через valega и отмечает в базе
  #
  class IncomeTransactionsAnalyser < Base
    SLEEP_INTERVAL = 10 # seconds
    BATCH_SIZE = 100

    # Result of ValegaClient.new.risk_assets_types
    #
    VALEGA_ASSETS_TYPES = [{"id"=>"wvaVWgVy9p", "name"=>"Bitcoin", "code"=>"BTC"},
                           {"id"=>"Qkqz8909GX", "name"=>"Ethereum", "code"=>"ETH"},
                           {"id"=>"9xLV1MVON2", "name"=>"XRP", "code"=>"XRP"},
                           {"id"=>"YqGzbE79Nw", "name"=>"Tether", "code"=>"USDT"},
                           {"id"=>"dMj7xB023b", "name"=>"Bitcoin Cash", "code"=>"BCH"},
                           {"id"=>"9EPVJjVGo1", "name"=>"Bitcoin SV", "code"=>"BSV"},
                           {"id"=>"Xd90dEVyOe", "name"=>"Litecoin", "code"=>"LTC"},
                           {"id"=>"6k8zB5729g", "name"=>"Dash", "code"=>"DASH"},
                           {"id"=>"Bq60REzRnk", "name"=>"Zcash", "code"=>"ZEC"},
                           {"id"=>"3qe7g4zaQk", "name"=>"Stellar", "code"=>"XLM"},
                           {"id"=>"dpbzOGzkJ5", "name"=>"USD Coin", "code"=>"USDC"}]

    VALEGA_ASSETS_CODES = Set.new(VALEGA_ASSETS_CODES.map { |c| c.fetch('code') }).freeze

    ETHEREUM_CODES = %w[MDT ETC DAI USDC USDT MCR].freeze
    BITCOIN_FORKS = %w[BTC DOGE LTC DASH BCH].freeze
    OUR_CODES = Set.new(ETHEREUM_CODES + BITCOIN_FORKS).freeze

    ANALYZABLE_CODES = VALEGA_ASSETS_CODES.intersection OUR_CODES

    def self.scope
      BlockchainTx
        .income
        .where(cc_code: ANALYZABLE_CODES.to_a)
    end

    def process
      Rails.logger.info("Start process with #{ANALYZABLE_CODES.to_a.join(',')} analyzable codes")
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
    rescue StandardError => e
      report_exception e
    end
  end
end
