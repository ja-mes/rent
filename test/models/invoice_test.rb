require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  def setup
    @invoice = invoices(:one)
  end

  test "invoice should be valid" do
    assert @invoice.valid?
  end

  test 'user should be present' do
    @invoice.user = nil
    assert_not @invoice.valid?
  end

  test 'customer should be present' do
    @invoice.customer = nil
    assert_not @invoice.valid?
  end

  test 'amount should be present' do
    @invoice.amount = nil
    assert_not @invoice.valid?
  end

  test 'amount should not be negative' do
    @invoice.amount = -2.25
    assert_not @invoice.valid?
  end

  test 'amount should have a maximum of 2 decimals' do
    @invoice.amount = 2.222
    assert_not @invoice.valid?
  end

  test 'date should be present' do
    @invoice.date = nil
    assert_not @invoice.valid?
  end

  test "should be valid whether or not memo is present" do
    @invoice.memo = nil
    assert @invoice.valid?
  end

  test "totals must equal should ensure that totals of expenses and invoice equal" do
    @invoice.amount = 200
    assert_not @invoice.valid?
  end

  test "after_create should work" do
    invoice = @invoice.dup
    invoice.due_date = Date.today

    @invoice.account_trans.each do |t|
      t.user = users(:one)
      invoice.account_trans << t.dup
    end

    assert_difference 'Tran.count' do
      invoice.save
      assert_equal invoice.customer.balance, invoice.amount
    end
  end

  test "after_update should work" do
    @invoice.date = "2016-08-07"
    @invoice.due_date = @invoice.date
    @invoice.customer = customers(:three)
    @invoice.save
    assert_equal @invoice.tran.date, @invoice.date
    assert_equal @invoice.tran.customer, customers(:three)
  end

  test "after_destroy should work" do
    @invoice.destroy
    assert_equal @invoice.customer.balance, -@invoice.amount
  end

  test "after_destroy should not remove balance if charged is false" do
    @invoice.charged = false

    assert_difference "@invoice.customer.balance", 0 do
      @invoice.destroy
    end
  end

  test "calculate_balance should work" do
    @invoice.amount = 200
    @invoice.calculate_balance(500, customers(:one))
    assert_equal @invoice.customer.balance, -300
  end

  test "calculate_balance should work if this is a new customer" do
    @invoice.amount = 500
    @invoice.customer = customers(:three)
    @invoice.calculate_balance(200, customers(:one))
    assert_equal @invoice.customer.balance, 500
    assert_equal customers(:one).balance, -200
  end

  test "enter recurring tran should create invoice from supplied tran" do
    tran = recurring_trans(:one)
    invoice = nil

    assert_difference ['Invoice.count', 'AccountTran.count', 'Tran.count'] do
      invoice = Invoice.enter_recurring_tran(tran)
    end

    assert_equal invoice.user_id, tran.user_id
    assert_equal invoice.date, Date.today
    assert_equal invoice.amount, tran.amount
    assert_equal invoice.memo, tran.memo
    assert_equal invoice.customer_id, tran.charge_id
  end

  test "inc balance should increment customer balance for amount of invoice if due_date is today" do
    @invoice.due_date = Date.today
    @invoice.amount = 500

    assert_difference '@invoice.customer.balance', 500 do
      @invoice.inc_balance
    end
  end

  test "inc balance should increment customer blaance for amount of invoice if due_date is < today" do
    @invoice.due_date = Date.yesterday
    @invoice.amount = 500

    assert_difference '@invoice.customer.balance', 500 do
      @invoice.inc_balance
    end
  end

  test "inc balance should not inc balance if due_date is greater than todays date" do
    @invoice.due_date = Date.tomorrow
    @invoice.amount = 500

    assert_difference '@invoice.customer.balance', 0 do
      @invoice.inc_balance
    end

    @invoice.due_date = Date.tomorrow + 2.months

    assert_difference '@invoice.customer.balance', 0 do
      @invoice.inc_balance
    end
  end

  test "check_due_date should check to see if due_date is in the future and if it is then set charged to false" do
    @invoice.charged = true
    @invoice.due_date = Date.tomorrow

    @invoice.check_due_date
    assert_equal @invoice.charged, false

    @invoice.charged = true
    @invoice.due_date = Date.tomorrow + 10.days + 5.months

    @invoice.check_due_date
    assert_equal @invoice.charged, false
  end

  test "create_invoice_tran" do
    @invoice.tran.destroy
    assert_difference 'Tran.count', 1 do
      @invoice.create_invoice_tran
    end
  end
end
