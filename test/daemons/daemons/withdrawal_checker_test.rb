require "test_helper"
require 'webmock/minitest'

class Daemons::WithdrawalCheckerTest < ActiveSupport::TestCase
  setup do
    ENV['BITZLATO_API_URL'] = 'http://bitzlato_api.example'
    ENV['P2P_API_ADM_JWK'] = '{ "kty": "EC", "d": "M6zhmFlGMVvOfopcHyD9ph8ljZ9sl5yqzgYenqDzV8o", "crv": "P-256", "x": "SF5i-hlPLub1vu8N2LH9S6yxm4jdPLojrUpiufEJW8U", "y": "IRWfAutSCureDjoOSnYNdOr75AV_dCo_mBuNuixaOnw" }'

    @checker = Daemons::WithdrawalChecker.new
    @withdrawal = withdrawals(:aml)
  end

  def stub_freeze_request
    stub_request(:post, "#{ENV['BITZLATO_API_URL']}/admin/p2p/freeze/#{@withdrawal.user_id}/")
  end

  test 'change status from aml to pending' do
    stub_freeze_request.to_return(status: 200)

    AddressVerifier.stub_any_instance(:pass?, true) do
      @checker.process
      assert @withdrawal.reload.status == 'pending'
    end
  end

  test 'success attempt to freeze user' do
    stub_freeze_request.to_return(status: 200)

    AddressVerifier.stub_any_instance(:pass?, false) do
      @checker.process
      assert @withdrawal.reload.status == 'aml'
    end
  end

  test 'failed attempt to freeze user' do
    stub_freeze_request.to_return(status: 401)

    AddressVerifier.stub_any_instance(:pass?, false) do
      assert_raises do
        @checker.process
      end

      assert @withdrawal.reload.status == 'aml'
    end
  end
end
