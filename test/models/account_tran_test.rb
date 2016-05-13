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
    assert_equal trans.calculate_total(accounts(:one)), -29.97
  end

  test "calculate total should work for dec accounts" do
    trans = AccountTran.where(amount: 9.99, account_transable_type: "Check").limit(2)

    assert_equal trans.calculate_total(accounts(:two)), 19.98
  end

  test "should subtract checks and add invoices" do
    trans = account_trans(:one).merge account_trans(:check1)
    assert_equal trans.calculate_property_total, account_trans(:one) - account_trans(:check1)
  end

  test "date range should return transactions for a date range" do
   trans = AccountTran.all.limit(3).date_range(
      {'date(1i)' => "2016", "date(2i)" => "7", "date(3i)" => "7" },
      {'date(1i)' => "2016", "date(2i)" => "8", "date(3i)" => "7" }
    )

   assert_equal trans.count, 3
  end
end
