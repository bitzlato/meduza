# frozen_string_literal: true

module AMQP
  class Base # rubocop:disable Lint/EmptyClass
    attr_reader :logger

    BLOCKCHAIN_MAP = {
      'btc' => 'BITCOIN',
      'polygon-mainnet' => 'POLYGON',
      'bsc-mainnet' => 'BSC',
      'heco-mainnet' => 'HECO',
      'tron-mainnet' => 'TRON',
      'bitoto-tron-mainnet' => 'TRON',
      'eth-mainnet' => 'ETHEREUM',
      'p2p-doge-mainnet' => 'DOGE',
      'p2p-eth-mainnet' => 'ETHEREUM',
      'p2p-dash-mainnet' => 'DASH',
      'p2p-ltc-mainnet' => 'LITECOIN',
      'p2p-bch-mainnet' => 'BITCOINCASH',
      'p2p-btc-mainnet' => 'BITCOIN',
      'p2p-tron-mainnet' => 'TRON',
      'p2p-bsc-mainnet' => 'BSC'
    }.freeze

    def initialize
      @logger = Rails.logger.tagged self.class.name
    end

    def lookup_blockchain(blockchain)
      BLOCKCHAIN_MAP[blockchain] || blockchain
    end
  end
end
