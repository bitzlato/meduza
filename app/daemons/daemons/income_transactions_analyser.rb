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

    # TODO Проверять в одной валеговской транзкции сразу все транзакции по разным валютам
    def process
      Rails.logger.info("Start process with #{ANALYZABLE_CODES.to_a.join(',')} analyzable codes")
      ANALYZABLE_CODES.each do |cc_code|
        transaction_source = TransactionSource.find_or_create_by!(cc_code: cc_code)
        transaction_source.reload
        last_id = TransactionAnalysis.where(cc_code: cc_code).maximum(:blockchain_tx_id)
        Rails.logger.info("Last processed blockchain tx_id for #{cc_code} is #{last_id}")
        btxs = self.class.scope
          .where('id > ?', last_id.to_i)
          .where(cc_code: cc_code)
          .order(:id)
          .limit(ValegaClient::MAX_ELEMENTS)
          .to_a

        # Докидываем на проверку старые транзакции
        if btxs.count < ValegaClient::MAX_ELEMENTS && cc_code == 'BTC'
          ids = $redis.srandmember('txids', ValegaClient::MAX_ELEMENTS - btxs.count)
          if ids.empty?
            Rails.logger.info('No legacy transcations in the pool')
          else
            Rails.logger.info("Add legacy transactions to check #{ids}")
            btxs += BlockchainTx.where(id: ids).to_a
          end
        end

        unless btxs.any?
          Rails.logger.info("No new blockchain transactions for cc_code=#{cc_code} (last id #{last_id})")
          next
        end
        Rails.logger.info("Process blockchain transactions with id=#{btxs.pluck(:id).join(',')} for #{cc_code}")
        ValegaAnalyzer.new.analyze_transaction btxs, cc_code
        btxs.pluck(:id).each do |id|
          $redis.srem 'txids', id.to_i
        end
        last_id = btxs.pluck(:id).max
        transaction_source.update! last_processed_blockchain_tx_id: last_id if last_id > transaction_source.last_processed_blockchain_tx_id
        break unless @running
      rescue ValegaClient::TooManyRequests => err
        report_exception err, true
        Rails.logger.error "Retry: #{err.message}"
        sleep 1
        retry
      rescue StandardError => e
        report_exception e, true, cc_code: cc_code
      end
    end
  end
end
