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

  test "amount can be negative" do
    @tran.amount = -500
    assert @tran.valid?
  end

  test "date should be present" do
    @tran.date = nil
    assert_not @tran.valid?
  end

  test "calculate total should calculate balance" do
    trans = accounts(:one).account_trans
    assert_equal trans.calculate_total(accounts(:one)), 480.24
  end

  test "calculate total should work for dec accounts" do
    trans = accounts(:one).account_trans
    debugger
    assert_equal trans.calculate_total(accounts(:two)), -480.24
  end

  test "should subtract checks and add invoices" do
    trans = properties(:one).account_trans
    assert_equal trans.calculate_property_total, account_trans(:one).amount + account_trans(:check1).amount
  end

  test "date range should return transactions for a date range" do
   trans = AccountTran.all.limit(3).date_range(
      {'date(1i)' => "2016", "date(2i)" => "7", "date(3i)" => "7" },
      {'date(1i)' => "2016", "date(2i)" => "8", "date(3i)" => "7" }
    )

   assert_equal trans.count, 3
  end
end
