require 'jwt_sig'
require 'faraday/detailed_logger'

class BitzlatoAPI
  attr_reader :url, :debug, :logger

  def initialize(url: ENV.fetch('BITZLATO_API_URL'))
    @url = URI url
    @logger = Logger.new Rails.application.root.join('log/bitzlato_api.log')
    @logger.level = Logger::DEBUG
  end

  def jwt_freeze_user(user_id, params)
    build_connection.
      post(url.path + "/admin/p2p/freeze/#{user_id}/", JSON.generate(params))
  end

  def key_freeze_user(user_id, params)
    build_connection.
      put(url.path + "/freezing/freeze/#{user_id}/", JSON.generate(params))
  end

  private

  def headers
    {
      'X-Access-Key' => ENV.fetch('BITZLATO_FREEZE_API_KEY')
    }
  end

  def build_connection(claims = {})
    Faraday.new(url: url, headers: headers) do |c|
      c.use Faraday::Response::Logger
      c.headers = {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
      }
      c.request :url_encoded
      c.request :curl, logger, :debug
      # c.request :authorization, 'Bearer', JWTSig.meduza_sig.encode(claims)
      c.response :detailed_logger, logger if ENV.true?('LOG_API_RESPONSE')
      yield c if block_given?
    end
  end
end
