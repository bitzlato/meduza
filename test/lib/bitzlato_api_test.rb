require "test_helper"
require 'bitzlato_api'

class BitzlatoAPITest < ActiveSupport::TestCase
  setup do
    @conn = Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.post(/\A\/admin\/p2p\/freeze\/(\d+)\/\z/) do |env, meta|
          [200,
           {'Content-Type' => 'text/plain'},
           "user_id: #{meta[:match_data][1]}"
          ]
        end
      end
    end

    @bz_api = BitzlatoAPI.new(url: 'http://example.com', debug: false)
  end

  test 'set X-Access-Key header' do
    secret = 'blablabla'
    response = @bz_api.freeze_user(1, connection: @conn, params: { reason: 'Test Freeze' } )
    assert response.success?
  end
end
