class BitzlatoAPI
  attr_reader :url, :debug

  def initialize(url: ENV.fetch('BITZLATO_API_URL'), debug: ENV.true?('BITZLATO_CURL_LOGGER'))
    @url = url
    @debug = debug
  end

  def freeze_user(user_id, params: {}, connection: nil, claims: {})
    connection ||= build_connection(claims)
    connection.post("/admin/p2p/freeze/#{user_id}/", JSON.generate(params))
  end

  private

  def build_connection(claims: {})
    Faraday.new(url: url) do |c|
      c.use Faraday::Response::Logger
      c.headers = {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
      }
      c.request :curl, Rails.logger, :debug if debug
      c.request :authorization, 'Bearer', JWTSig.meduza_sig.encode(claims)
      yield c if block_given?
    end
  end
end
