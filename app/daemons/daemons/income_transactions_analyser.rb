module Daemons
  # Берёт все не обработанные транзакции из blockchain_tx
  # Собирает по ним входящие адреса
  # Проверяет эти адреса через valega и отмечает в базе
  #
  class IncomeTransactionsAnalyser < Base
    SLEEP_INTERVAL = 1 # seconds
    BATCH_SIZE = ValegaClient::MAX_ELEMENTS

    VALEGA_ASSETS_CODES = Set.new(ValegaClient::ASSETS_TYPES.map { |c| c.fetch('code') }).freeze

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
      ANALYZABLE_CODES.each do |cc_code|
        TransactionSource.where(cc_code: cc_code).find_each do |transaction_source|
          self.class.scope
              .where('id > ?', transaction_source.last_processed_blockchain_tx_id)
              .find_in_batches(batch_size: BATCH_SIZE) do |btxs|
            Rails.logger.info("Process id=#{btxs.pluck(:id).join(',')} for #{cc_code}")
            ValegaAnalyzer.new.analyze_transaction btxs, cc_code
            transaction_source.update! last_processed_blockchain_tx_id: btxs.pluck(:id).max
          end
        end
        Rails.logger.info("Sleep for #{SLEEP_INTERVAL}")
        sleep SLEEP_INTERVAL
      rescue StandardError => e
        report_exception e
      end
    end
  end
end
