require 'net/https'
require 'uri'
require 'json'

class BitcoinRPC
  HEADERS = { "Content-Type" => "application/json", "Cache-control" => "no-cache" }.freeze
  def initialize(service_url = ENV.fetch('BITCOIN_NODE'))
    @uri = URI.parse(service_url)
  end

  def method_missing(name, *args)
    post_body = { 'method' => name, 'params' => args, 'id' => 'jsonrpc' }.to_json
    resp = http_post_request(post_body)
    raise JSONRPCError, resp['error'] if resp['error']

    resp['result']
  end

  def http_post_request(post_body)
    faraday = Faraday.new(url: @uri.to_s, headers: HEADERS) do |conn|
      conn.request :curl, logger, :warn if ENV.true? 'FARADAY_LOGGER'
    end

    response = faraday.post do |req|
      req.body = post_body
    end

    raise "Wrong response status #{response.status}" unless response.status == 200

    JSON.parse response.body
  end

  def logger
    Logger.new($stdout)
  end

  class JSONRPCError < RuntimeError; end
end
