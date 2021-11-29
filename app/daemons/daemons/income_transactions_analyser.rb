module Daemons
  # Берёт все не обработанные транзакции из blockchain_tx
  # Собирает по ним входящие адреса
  # Проверяет эти адреса через valega и отмечает в базе
  #
  class IncomeTransactionsAnalyser < Base
    @sleep_time = 2.seconds


    VALEGA_ASSETS_CODES = Set.new(ValegaClient::ASSETS_TYPES.map { |c| c.fetch('code') }).freeze

    ETHEREUM_CODES = %w[ETH MDT ETC DAI USDC USDT MCR].freeze
    BITCOIN_FORKS = %w[BTC DOGE LTC DASH BCH].freeze
    OUR_CODES = Set.new(ETHEREUM_CODES + BITCOIN_FORKS).freeze

    ANALYZABLE_CODES = VALEGA_ASSETS_CODES.intersection OUR_CODES

    def self.scope
      BlockchainTx
        .receive
        .where(cc_code: ANALYZABLE_CODES.to_a)
    end

    def process
      Rails.logger.info("Start process with #{ANALYZABLE_CODES.to_a.join(',')} analyzable codes")
      ANALYZABLE_CODES.each do |cc_code|
        TransactionSource.where(cc_code: cc_code).find_each do |transaction_source|
          btxs = self.class.scope
            .where('id > ?', transaction_source.last_processed_blockchain_tx_id)
            .order(:id)
            .limit(ValegaClient::MAX_ELEMENTS)

          next unless btxs.any?
          Rails.logger.info("Process id=#{btxs.pluck(:id).join(',')} for #{cc_code}")
          ValegaAnalyzer.new.analyze_transaction btxs, cc_code
          transaction_source.update! last_processed_blockchain_tx_id: btxs.maximum(:id)
        rescue ValegaClient::TooManyRequests => err
          report_exception err, true
          Rails.logger.error "Retry: #{err.message}"
          sleep 1
          retry
        end
      rescue StandardError => e
        report_exception e, true, cc_code: cc_code
      end
    end
  end
end
