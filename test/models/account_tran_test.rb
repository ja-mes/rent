require 'test_helper'

class AccountTranTest < ActiveSupport::TestCase
  def setup
    @tran = account_trans(:one)
  end

  test "should belong to user" do
    assert users(:one).account_trans
  end

  test "should belong to accounts" do
    assert accounts(:one).account_trans
  end

  test "should belong to properties" do
    assert properties(:one).account_trans
  end

  test "user id should be present" do
    @tran.user = nil
    assert_not @tran.valid?
  end

  test "amount should be present" do
    @tran.amount = nil
    assert_not @tran.valid?
  end

  test "date should be present" do
    @tran.date = nil
    assert_not @tran.valid?
  end

  test "calculate total should calculate balance" do
    trans = AccountTran.where(amount: 9.99).limit(3)
    assert_equal trans.calculate_total, 29.97
  end

  test "date range should return transactions for a date range" do
   trans = AccountTran.all.limit(3).date_range(
      {'date(1i)' => "2016", "date(2i)" => "7", "date(3i)" => "7" },
      {'date(1i)' => "2016", "date(2i)" => "8", "date(3i)" => "7" }
    )

   assert_equal trans.count, 3
  end
end
