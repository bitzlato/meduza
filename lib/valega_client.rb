require 'faraday'

class ValegaClient
  include Singleton

  class Authorization
    attr_reader :access_token

    FALLBACK_SECONDS = 30

    def initialize(access_token: , expires_in: )
      @created_at = Time.zone.now
      @access_token = access_token
      @expires_in = expires_in
    end

    def expired?
      @created_at + @expires_in.seconds + FALLBACK_SECONDS < Time.zone.now
    end
  end

  MAX_ELEMENTS = 10 # https://www.valegachain.com/shield_platform/api/realtime_risk_monitor#risk_analysis
  URL = 'https://valegachainapis.com/'.freeze
  HEADERS = { "Content-Type" => "application/json", "Cache-control" => "no-cache" }.freeze

  # Result of ValegaClient.new.risk_assets_types
  #
  ASSETS_TYPES = [{"id"=>"wvaVWgVy9p", "name"=>"Bitcoin", "code"=>"BTC"},
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

  def self.get_asset_type_id(cc_code)
    (
      ASSETS_TYPES.find { |a| a.fetch('code') == cc_code} || raise("No asset type for code #{cc_code} found")
    ).fetch('id')
  end

  def risk_analysis(address_transactions:, asset_type_id: nil, show_details: nil)
    address_transactions = Array(address_transactions)
    conn = Faraday.new(url: URL, headers: HEADERS) do |conn|
      conn.request :curl, logger, :warn if ENV.true? 'FARADAY_LOGGER'
      conn.request :authorization, 'Bearer', authorization.access_token
    end
    raise 'maximum 10 address/transactions available' if address_transactions.count > MAX_ELEMENTS
    raise 'address_transactions must be an Array' unless address_transactions.is_a? Array

    data = { data: address_transactions }
    data[:show_details] = show_details unless show_details.nil?
    data[:asset_type_id] = asset_type_id unless asset_type_id.nil?
    response = conn.post '/realtime_risk_monitor/risk/analysis' do |req|
      req.body = data.to_json
    end
    parse_response response
  end

  def risk_assets_types
    conn = Faraday.new(url: URL, headers: HEADERS) do |conn|
      conn.request :curl, logger, :warn if ENV.true? 'FARADAY_LOGGER'
      conn.request :authorization, 'Bearer', authorization.access_token
    end

    parse_response conn.get '/realtime_risk_monitor/risk/assets'

    # {"id"=>"wvaVWgVy9p", "name"=>"Bitcoin", "code"=>"BTC"}
    # {"id"=>"Qkqz8909GX", "name"=>"Ethereum", "code"=>"ETH"}
    # {"id"=>"9xLV1MVON2", "name"=>"XRP", "code"=>"XRP"}
    # {"id"=>"YqGzbE79Nw", "name"=>"Tether", "code"=>"USDT"}
    # {"id"=>"dMj7xB023b", "name"=>"Bitcoin Cash", "code"=>"BCH"}
    # {"id"=>"9EPVJjVGo1", "name"=>"Bitcoin SV", "code"=>"BSV"}
    # {"id"=>"Xd90dEVyOe", "name"=>"Litecoin", "code"=>"LTC"}
    # {"id"=>"6k8zB5729g", "name"=>"Dash", "code"=>"DASH"}
    # {"id"=>"Bq60REzRnk", "name"=>"Zcash", "code"=>"ZEC"}
    # {"id"=>"3qe7g4zaQk", "name"=>"Stellar", "code"=>"XLM"}
    # {"id"=>"dpbzOGzkJ5", "name"=>"USD Coin", "code"=>"USDC"}
  end

  private

  def parse_response(response)
    data = JSON.parse response.body
    raise [data.fetch('message'), data.fetch('error')].join('; ') unless data.fetch('result')

    data.fetch('data')
  end

  def authorization
    @authorization = authorize if @authorization.nil? || @authorization.expired?
    @authorization
  end

  def logger
    Logger.new($stdout)
  end

  def authorize(company_username: ENV.fetch('VALEGA_COMPANY_USERNAME'),
                company_password: ENV.fetch('VALEGA_COMPANY_PASSWORD'),
                username: ENV.fetch('VALEGA_API_USERNAME'),
                password: ENV.fetch('VALEGA_API_PASSWORD'))

    url = URI("#{URL}oauth/token/get")
    url.user = CGI.escape(company_username)
    url.password = CGI.escape(company_password)

    conn = Faraday.new(url: url.to_s, headers: HEADERS) do |conn|
      conn.request :curl, logger, :warn if ENV.true? 'FARADAY_LOGGER'
    end

    response = conn.post('/oauth/token/get') do |req|
      req.body = { "grant_type": "password", "username": username, "password": password }.to_json
    end

    raise response.body unless response.status == 200

    response = JSON.parse response.body

    Authorization.new(response.slice('access_token', 'expires_in').symbolize_keys)
  end
end
