require "test_helper"

class Daemons::WithdrawalCheckerTest < ActiveSupport::TestCase
  setup do
    @checker = Daemons::WithdrawalChecker.new
    @withdrawal = withdrawals(:aml)
  end

  test 'change status from aml to pending' do
    AddressVerifier.stub_any_instance(:pass?, true) do
      @checker.process
    end
    assert @withdrawal.reload.status == 'pending'
  end

  test 'success attempt to freeze user' do
    response = MiniTest::Mock.new
    response.expect(:success?, true)
    bz_api = MiniTest::Mock.new
    bz_api.expect(:freeze_user, response, [@withdrawal.user_id])

    AddressVerifier.stub_any_instance(:pass?, false) do
      BitzlatoAPI.stub :new, bz_api do
        @checker.process
      end
    end
    assert @withdrawal.reload.status == 'aml'
    response.verify
    bz_api.verify
  end

  test 'failed attempt to freeze user' do
    response = MiniTest::Mock.new
    response.expect(:success?, false)
    bz_api = MiniTest::Mock.new
    bz_api.expect(:freeze_user, response, [@withdrawal.user_id])

    AddressVerifier.stub_any_instance(:pass?, false) do
      BitzlatoAPI.stub :new, bz_api do
        assert_raises do
          @checker.process
        end
      end
    end
    assert @withdrawal.reload.status == 'aml'
    response.verify
    bz_api.verify
  end
end
