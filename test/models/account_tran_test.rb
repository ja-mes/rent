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
end
