require 'test_helper'

class CheckTest < ActiveSupport::TestCase
  def setup
    @check = checks(:one)
  end

  test "should be valid" do
    assert @check.valid?
  end

  test "should belong to user" do
    @check.user_id = nil
    assert_not @check.valid?
  end

  test "user should have many checks" do
    assert users(:one).checks
  end

  test "amount should be present" do
    @check.amount = nil
    assert_not @check.valid?
  end

  test "amount should not be negative" do
    @check.amount = -10
    assert_not @check.valid?
  end

  test "amount should have a max of two decimals" do
    @check.amount = 50.222
    assert_not @check.valid?
  end

  test "date should be present" do
    @check.date = nil
    assert_not @check.valid?
  end

  test "num can be nil" do
    @check.num = nil
    assert @check.valid?
  end

  test "num can be any string value" do
    @check.num = "50"
    assert @check.valid?

    @check.num = "ADJ"
    assert @check.valid?
  end

  test "should have many account trans" do
    assert @check.account_trans
  end

  test "should have at least one account tran" do
    @check.account_trans.destroy_all
    assert_not @check.valid?
  end

  test "update_if_cleared should update cleared balance for checkbook" do
    checkbook = registers(:one)
    @check.cleared = true
    @check.amount = 500

    assert_difference "checkbook.reload.cleared_balance", -490.01 do
      @check.update_if_cleared
    end
  end

  test "remove if cleared should remove check amount from checkbook cleared balance" do
    checkbook = registers(:one)
    @check.cleared = true
    @check.amount = 500

    assert_difference "checkbook.reload.cleared_balance", 500 do
      @check.remove_cleared
    end
  end

  test "after_create should update account balance" do
    account = registers(:one)
    check = @check.dup
    check.amount = 500
    @check.account_trans.each do |t| 
      t.user = users(:one)
      t.amount = -500
      check.account_trans << t.dup 
    end

    assert_difference 'account.balance', -500 do
      check.save
      account.reload
    end
  end

  test "after_update should update check tran" do
    check = @check.dup
    check.date = "4/12/2016".to_date
    @check.account_trans.each do |t| 
      t.user = users(:one)
      check.account_trans << t.dup 
    end

    check.save
    assert_equal check.tran.date, Date.strptime("4/12/2016", "%d/%m/%Y")
  end

  test "after_destroy should update account balance" do
    @check.amount = 500
    @check.destroy
    assert_equal registers(:one).balance, @check.amount
  end

  test "calculate balance should update check balance" do
    account = registers(:one)
    @check.amount = 200.25
    assert_difference 'account.balance', 299.75 do
      @check.calculate_balance 500
      account.reload
    end
  end

  test "date range should return transactions for date range" do
   trans = Check.all.limit(2).date_range(
      {'date(1i)' => "2016", "date(2i)" => "4", "date(3i)" => "28" },
      {'date(1i)' => "2016", "date(2i)" => "5", "date(3i)" => "28" }
    )

   assert_equal trans.count, 2
  end

  test "enter recurring tran should create check from the supplied tran" do
    tran = recurring_trans(:one)
    check = nil

    assert_difference ['Check.count', 'AccountTran.count', 'Tran.count'] do
      check = Check.enter_recurring_tran(tran)
    end

    assert_equal check.user_id, tran.user_id
    assert_equal check.num, tran.num.to_s
    assert_equal check.date, Date.today
    assert_equal check.amount, tran.amount
    assert_equal check.memo, tran.memo
    assert_equal check.vendor_id, tran.charge_id
  end

  test "enter_reconciliation_discrepancy should enter vendorless checks for reconciliation discrepancy" do
    assert_difference ['Check.count', 'AccountTran.count', 'Tran.count'] do
      check = Check.enter_reconciliation_discrepancy(users(:one), 35)
      account_tran = check.account_trans.first

      assert_equal check.user, users(:one)
      assert_equal check.num, "ADJ"
      assert_equal check.date, Date.today
      assert_equal check.amount, 35
      assert_equal check.memo, "Reconcile adjustment"

      assert_equal check.account_trans.count, 1
      assert_equal account_tran.user, users(:one)
      assert_equal account_tran.account, accounts(:reconcile_discrepancies)
      assert_equal account_tran.amount, -35
      assert_equal account_tran.memo, ""
      assert_nil account_tran.property
      assert_equal account_tran.date, check.date
    end
  end
end
