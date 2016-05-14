require 'test_helper'

class DepositTest < ActiveSupport::TestCase
  def setup
    @deposit = deposits(:one)
  end

  test "deposit should be valid" do
    assert @deposit.valid?
  end

  test "user should have many deposits" do
    assert users(:one).deposits
  end

  test "should have many payments" do 
    assert @deposit.payments
  end

  test "should have one tran" do
    assert @deposit.tran
  end

  test "user should be present" do
    @deposit.user_id = nil
    assert_not @deposit.valid?
  end

  test "date should be present" do
    @deposit.date = nil
    assert_not @deposit.valid?
  end

  test "amount should be present" do
    @deposit.amount = nil
    assert_not @deposit.valid?
  end

  test "amount should not be negative" do
    @deposit.amount = -5
    assert_not @deposit.valid?
  end

  test "amount should not have more than two decimal places" do
    @deposit.amount = -5.25
    assert_not @deposit.valid?
  end


  test "create_deposit_trans should create account_tran for deposit and discrepancies" do
    @deposit.account_trans = []
    @deposit.amount = 50
    @deposit.discrepancies = 20

    assert_difference 'AccountTran.count', 2 do
      @deposit.create_deposit_trans
    end

    assert_equal @deposit.account_trans.first.amount, 30
    assert_equal @deposit.account_trans.second.amount, 20
  end

  test "create_deposit_trans should not create discrepancies account_tran if no discrepancies exist" do
    assert_difference 'AccountTran.count', 1 do
      @deposit.create_deposit_trans
    end
  end

  test "create_deposit_trans should create tran for deposit" do
    @deposit.tran = nil

    assert_difference "Tran.count" do
      @deposit.create_deposit_trans
    end
  end

  test "update tran should update trans" do
    @deposit.amount = 200.25 
    @deposit.discrepancies = 25.80
    @deposit.date = "05/03/2016"

    @deposit.update_tran

    assert_equal @deposit.tran.date, "05/03/2016".to_date
    assert_equal @deposit.account_trans.first.amount, 200.25 - 25.80
    assert_equal @deposit.account_trans.second.amount, 25.80
  end

  test "update tran should destroy discrepancies if they are removed" do
    @deposit.discrepancies = nil

    @deposit.update_tran
    assert_equal @deposit.account_trans.count, 1
  end

  test "update tran should update only deposit account tran if no discrepancies exist" do
    @deposit.discrepancies = nil
    @deposit.account_trans.second.destroy
    @deposit.amount = 500.85
    @deposit.update_tran
    assert_equal @deposit.account_trans.first.amount, 500.85
  end

  test "remove amount should remove amount from checking account" do
    account = accounts(:four)

    assert_difference 'account.balance', -@deposit.amount do
      @deposit.remove_amount
      account.reload
    end
  end

  test "calculate balance should increment balance if no old_amount is supplied" do
    account = accounts(:four)
    @deposit.amount = 500
    
    assert_difference 'account.balance', 500 do
      @deposit.calculate_balance
      account.reload
    end
  end

  test "calculate balance should update balance if old_amont is supplied" do
    account = accounts(:four)
    @deposit.amount = 500 # 500 is the old amount

    assert_difference 'account.balance', 300 do
      @deposit.calculate_balance 200
      account.reload
    end
  end

  test "create discrepancies should create discrepancies" do
    @deposit.discrepancies = 500.25
    @deposit.create_discrepancies
    assert_equal @deposit.account_trans.third.amount, 500.25
  end
end
