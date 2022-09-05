require "test_helper"

class Daemons::WithdrawalCheckerTest < ActiveSupport::TestCase
  setup do
    @checker = Daemons::WithdrawalChecker.new
  end

  test '#process' do
    withdrawal = withdrawals(:aml)
    withdrawal_check = withdrawals(:aml_check)
    AMQP::Queue.stub :publish, nil do
      @checker.process
    end
    assert withdrawal.reload.status == 'pending'
    assert withdrawal_check.reload.status == 'aml'
    assert withdrawal_check.reload.meduza_status['status'] == 'pended'
  end
end
