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

  test "setup_last_charged should add last_charged attr to tran" do
    tran = RecurringTran.new(due_date: "5")

    assert_equal tran.last_charged, Date.new(Date.today.year, Date.today.month, tran.due_date.to_i)
  end

  test "update_last_charged should update last_charged for updated due_date" do
    @tran.last_charged = Date.today.beginning_of_month
    @tran.due_date = "12"
    @tran.update_last_charged
    assert_equal @tran.last_charged, Date.today.beginning_of_month + 11
  end

  test "next_entry date should return 1 month from last charged date" do
    @tran.last_charged = Date.today.prev_month
    assert_equal @tran.next_entry_date, Date.today
  end

  test "after_entry should update last_entry and last_charged attributes" do
    @tran.last_charged = 1.month.ago
    @tran.last_entry = 1.month.ago
    @tran.after_entry
    assert_equal @tran.last_charged, Date.today.beginning_of_month
    assert_equal @tran.last_entry, Date.today
  end

  test "memorize should save checks" do
    check = checks(:one)
    account_tran = check.account_trans.first
    tran = nil

    assert_difference "RecurringTran.count" do
      tran = RecurringTran.memorize check, "3", "foobar"
    end

    assert_equal tran.description, "foobar"
    assert_equal tran.user, check.user
    assert_equal tran.amount, check.amount
    assert_equal tran.memo, check.memo
    assert_equal tran.due_date, "3"
    assert_equal tran.tran_type, "Check"
    assert_equal tran.account_trans, [{
      "account_id" => account_tran.account_id.to_s,
      "amount" => account_tran.amount.to_s,
      "memo" => account_tran.memo,
      "property_id" => account_tran.property_id.to_s
    }]
  end

  test "memorize should save invoices" do
    invoice = invoices(:one)
    account_tran = invoice.account_trans.first
    tran = nil

    assert_difference "RecurringTran.count" do
      tran = RecurringTran.memorize invoice, "5", "test"
    end

    assert_equal tran.description, "test"
    assert_equal tran.user, invoice.user
    assert_equal tran.amount, invoice.amount
    assert_equal tran.memo, invoice.memo
    assert_equal tran.due_date, "5"
    assert_equal tran.tran_type, "Invoice"
    assert_equal tran.account_trans, [{
      "account_id" => account_tran.account_id.to_s,
      "amount" => account_tran.amount.to_s,
      "memo" => account_tran.memo,
      "property_id" => account_tran.property_id.to_s,
    }]
  end
end
