class BitzlatoAPI
  attr_reader :connection

  def initialize(connection: nil,
                 bearer: nil,
                 url: ENV.fetch('BITZLATO_API_URL'),
                 debug: ENV.true?('BITZLATO_CURL_LOGGER'))
    @connection = connection || Faraday.new(url: url) do |c|
                                  c.use Faraday::Response::Logger
                                  c.headers = {
                                    'Content-Type' => 'application/json',
                                    'Accept' => 'application/json',
                                  }
                                  c.request :curl, Rails.logger, :debug if debug
                                  c.request :authorization, 'Bearer', bearer if bearer
                                end
  end

  def freeze_user(user_id, secret = ENV.fetch('BITZLATO_FREEZE_SECRET'))
    connection.post("api/freezing/freeze/#{user_id}/") do |conn|
      conn.headers['X-Access-Key'] = secret
    end
  end
end
