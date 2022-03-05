require "test_helper"
require 'bitzlato_api'

class BitzlatoAPITest < ActiveSupport::TestCase
  setup do
    ENV['BITZLATO_API_URL'] = '1'
    @conn = Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.post(/\A\/api\/freezing\/freeze\/(\d+)\/\z/) do |env, meta|
          [200,
           {'Content-Type' => 'text/plain'},
           "user_id: #{meta[:match_data][1]}"
          ]
        end
      end
    end

    @bz_api = BitzlatoAPI.new(connection: @conn)
  end

  test 'set X-Access-Key header' do
    secret = 'blablabla'
    response = @bz_api.freeze_user(1, secret)
    assert response.env.request_headers['X-Access-Key'] == secret
  end
end
