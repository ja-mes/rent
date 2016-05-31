require 'test_helper'

class RecurringTranTest < ActiveSupport::TestCase
  def setup
    @tran = recurring_trans(:one)
  end

  test "should be valid" do
    assert @tran.valid?
  end

  test "user_id should be present" do
    @tran.user_id = nil
    assert_not @tran.valid?
  end

  test "amount should be present" do
    @tran.amount = nil
    assert_not @tran.valid?
  end

  test "due_date should be present" do
    @tran.due_date = nil
    assert_not @tran.valid?
  end

  test "tran_type should be present" do
    @tran.tran_type = nil
    assert_not @tran.valid?
  end

  test "memorize should save checks" do
    check = checks(:one)
    account_tran = check.account_trans.first
    tran = nil

    assert_difference "RecurringTran.count" do
      tran = RecurringTran.memorize check, "3"
    end

    assert_equal tran.user, check.user
    assert_equal tran.amount, check.amount
    assert_equal tran.memo, check.memo
    assert_equal tran.due_date, "3"
    assert_equal tran.tran_type, "Check"
    assert_equal tran.account_trans, [{
      account_id: account_tran.account_id,
      amount: account_tran.amount,
      memo: account_tran.memo,
      property_id: account_tran.property_id
    }]
  end

  test "memorize should save invoices" do
    invoice = invoices(:one)
    account_tran = invoice.account_trans.first
    tran = nil

    assert_difference "RecurringTran.count" do
      tran = RecurringTran.memorize invoice, "5"
    end

    assert_equal tran.user, invoice.user
    assert_equal tran.amount, invoice.amount
    assert_equal tran.memo, invoice.memo
    assert_equal tran.due_date, "5"
    assert_equal tran.tran_type, "Invoice"
    assert_equal tran.account_trans, [{
      account_id: account_tran.account_id,
      amount: account_tran.amount,
      memo: account_tran.memo,
      property_id: account_tran.property_id,
    }]
  end
end
