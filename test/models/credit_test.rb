require 'test_helper'

class CreditTest < ActiveSupport::TestCase
  def setup
    @credit = credits(:one)
  end

  test "credit should be valid" do
    assert @credit.valid?
  end

  test "should belong to user" do
    assert users(:one).credits
  end

  test "should belong to customer" do
    assert customers(:one).credits
  end

  test "should have one tran" do
    assert @credit.tran
  end

  test "should have many account trans" do
    assert @credit.account_trans
  end

  test "amount should be present" do
    @credit.amount = nil
    assert_not @credit.valid?
  end

  test "date should be present" do
    @credit.date = nil
    assert_not @credit.valid?
  end

  test "account trans should be present" do
    @credit.account_trans = []
    assert_not @credit.valid?
  end

  test "create_credit_tran should create tran" do
    @credit.tran.destroy
    @credit.tran = nil

    assert_difference 'Tran.count', 1 do
      @credit.create_credit_tran
    end
  end

  test "update_credit_tran should update tran" do
    @credit.date = Date.today
    @credit.customer = customers(:three)

    @credit.update_credit_tran
    assert_equal @credit.tran.date, Date.today
    assert_equal @credit.tran.customer, customers(:three)
  end

  test "setup account_trans should setup account trans" do
    credit = @credit.dup
    @credit.account_trans.each do |t| 
      t.amount = credit.amount
      credit.account_trans << t 
    end

    credit.setup_account_trans

    credit.account_trans.each do |t|
      assert_equal t.user, credit.user
      assert_equal t.date, credit.date
      assert_equal t.amount, credit.amount *= -1
    end
  end

  test "add_balance should add credit amount to customer balance" do
    assert_difference '@credit.customer.balance', -@credit.amount do
      @credit.add_balance
    end
  end

  test "remove balance should remove balance from customer" do
    assert_difference '@credit.customer.balance', @credit.amount do
      @credit.remove_balance
    end
  end

  test "calculate_balance should work" do
    @credit.amount = 200
    @credit.calculate_balance(500, customers(:one))
    assert_equal @credit.customer.balance, 300
  end
end
