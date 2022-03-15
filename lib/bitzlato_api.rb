class BitzlatoAPI
  attr_reader :url, :debug

  def initialize(url: ENV.fetch('BITZLATO_API_URL'), debug: ENV.true?('BITZLATO_CURL_LOGGER'))
    @url = url
    @debug = debug
  end

  def freeze_user(user_id, params: {}, connection: nil, claims: {})
    connection ||= build_freeze_connection(claims)
    connection.post("api/freezing/freeze/#{user_id}/", JSON.generate(params))
  end

  private

  def build_freeze_connection(claims: {})
    build_connection do |conn|
      #conn.request :authorization, 'Bearer', JWTSig.feeze_sig.encode(claims)
      conn.headers['X-Access-Key'] = ENV.fetch('FREEZING_FREEZE_UNFREEZE_SECRET')
    end
  end

  def build_connection
    Faraday.new(url: url) do |c|
      c.use Faraday::Response::Logger
      c.headers = {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
      }
      c.request :curl, Rails.logger, :debug if debug
      yield c if block_given?
    end
  end
end
