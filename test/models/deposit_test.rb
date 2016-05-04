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

  test "create_tran should create tran for deposit" do
    deposit = @deposit.dup
    assert_difference 'Tran.count' do
      deposit.create_deposit_tran
    end
  end

  test "after update should update deposit" do
    @deposit.date = "4/12/2016".to_date
    @deposit.update_tran
    assert_equal @deposit.date, Date.strptime("4/12/2016", "%d/%m/%Y")
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
end