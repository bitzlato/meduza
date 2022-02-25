require 'valega_client'

VALEGA_ASSETS_CODES = Set.new(ValegaClient::ASSETS_TYPES.map { |c| c.fetch('code') }).freeze
ETHEREUM_CODES = %w[ETH MDT ETC DAI USDC USDT MCR].freeze
BITCOIN_FORKS = %w[BTC DOGE LTC DASH BCH].freeze
OUR_CODES = Set.new(ETHEREUM_CODES + BITCOIN_FORKS).freeze

ANALYZABLE_CODES = VALEGA_ASSETS_CODES.intersection OUR_CODES
