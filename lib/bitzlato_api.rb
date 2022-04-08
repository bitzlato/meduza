require 'jwt_sig'
require 'faraday/detailed_logger'

class BitzlatoAPI
  attr_reader :url, :debug, :logger

  def initialize(url: ENV.fetch('BITZLATO_API_URL'), debug: ENV.true?('BITZLATO_CURL_LOGGER'))
    @url = URI url
    @debug = debug
    @logger = Logger.new Rails.application.root.join('log/bitzlato_api.log')
    @logger.level = Logger::DEBUG
  end

  def freeze_user(user_id, params: {}, connection: nil, claims: {})
    connection ||= build_connection(claims)
    connection.post(url.path + "/admin/p2p/freeze/#{user_id}/", JSON.generate(params))
  end

  private

  def build_connection(claims: {})
    Faraday.new(url: url) do |c|
      c.use Faraday::Response::Logger
      c.headers = {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json',
      }
      c.request :url_encoded
      c.request :curl, logger, :debug
      c.response :detailed_logger, logger
      c.request :authorization, 'Bearer', JWTSig.meduza_sig.encode(claims)
      yield c if block_given?
    end
  end
end
