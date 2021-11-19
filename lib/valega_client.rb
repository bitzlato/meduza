require 'faraday'

class ValegaClient
  MAX_ELEMENTS = 10 # https://www.valegachain.com/shield_platform/api/realtime_risk_monitor#risk_analysis
  URL = 'https://valegachainapis.com/'.freeze
  HEADERS = { "Content-Type" => "application/json", "Cache-control" => "no-cache" }.freeze

  def risk_analysis(address_transactions:, access_type_id: nil, show_details: nil)
    address_transactions = Array(address_transactions)
    conn = Faraday.new(url: URL, headers: HEADERS) do |conn|
      conn.request :curl, logger, :warn if ENV.true? 'FARADAY_LOGGER'
      conn.request :authorization, 'Bearer', access_token
    end
    raise 'maximum 10 address/transactions available' if address_transactions.count > MAX_ELEMENTS
    raise 'address_transactions must be an Array' unless address_transactions.is_a? Array

    data = { data: address_transactions }
    data[:show_details] = show_details unless show_details.nil?
    data[:access_type_id] = access_type_id unless access_type_id.nil?
    response = conn.post '/realtime_risk_monitor/risk/analysis' do |req|
      req.body = data.to_json
    end
    parse_response response
  end

  def risk_assets_types
    conn = Faraday.new(url: URL, headers: HEADERS) do |conn|
      conn.request :curl, logger, :warn if ENV.true? 'FARADAY_LOGGER'
      conn.request :authorization, 'Bearer', access_token
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
    raise data.fetch('message') unless data.fetch('result')

    data.fetch('data')
  end

  def access_token
    @access_token || authorize
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
    response.fetch('access_token') || raise('no access token')
  end
end
