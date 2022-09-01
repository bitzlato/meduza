require "test_helper"
require 'bitzlato_api'

class BitzlatoAPITest < ActiveSupport::TestCase
  setup do
    @bz_api = BitzlatoAPI.new(url: 'http://example.com')
  end

  test 'set X-Access-Key header' do
    stub_request(:put, "http://example.com/api/freezing/freeze/1/")
      .to_return(status: 200, body: "user_id: 1", headers: { 'Content-Type' => 'text/plain' })
    response = @bz_api.freeze_user(1, { reason: 'Test Freeze' })
    assert response.success?
  end
end
