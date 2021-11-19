require 'net/https'
require 'uri'
require 'json'

class BitcoinRPC
  HEADERS = { "Content-Type" => "application/json", "Cache-control" => "no-cache" }
  def initialize(service_url = ENV.fetch('BITCOIN_NODE'))
    @uri = URI.parse(service_url)
  end

  def method_missing(name, *args)
    post_body = { 'method' => name, 'params' => args, 'id' => 'jsonrpc' }.to_json
    resp = JSON.parse( http_post_request(post_body) )
    raise JSONRPCError, resp['error'] if resp['error']
    resp['result']
  end

  def http_post_request(post_body)
    conn = Faraday.new(url: @uri.to_s, headers: HEADERS ) do |conn|
      conn.request :curl, logger, :warn if ENV.true? 'FARADAY_LOGGER'
    end

    conn.post do |req|
      req.body= post_body
    end.body
  end

  def logger
    Logger.new(STDOUT)
  end

  class JSONRPCError < RuntimeError; end
end
