require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  def setup
    @customer = customers(:one)
  end

  test "customer should be valid" do
    assert @customer.valid?
  end

  test "user should be present" do
    @customer.user = nil
    assert_not @customer.valid?
  end

  test "property should be present" do
    @customer.property = nil
    assert_not @customer.valid?
  end

  test "property not required if customer_type is blank " do
    @customer.customer_type = "blank"
    @customer.property = nil
    assert @customer.valid?
  end

  test "name_is_present should ensure that either customer name or company name exists" do
    @customer.first_name = " "
    @customer.last_name = ""
    @customer.company_name = ""

    assert_not @customer.valid?
  end

  test "should be valid if company name is present but not first or last name" do
    @customer.first_name = " "
    @customer.last_name = ""
    @customer.company_name = "foobar"

    assert @customer.valid?
  end

  test "should be valid if first or last_name is present but not company name" do
    @customer.first_name = "joe"
    @customer.last_name = "blah"
    @customer.company_name = ""

    assert @customer.valid?
  end

  test "rent should be present" do
    @customer.rent = nil
    assert_not @customer.valid?
  end

  test "rent not required if customer_type blank" do
    @customer.customer_type = "blank"
    @customer.rent = nil
    assert @customer.valid?
  end

  test "due_date should be present" do
    @customer.due_date = nil
    assert_not @customer.valid?
  end

  test "due_date not required if customer_type blank" do
    @customer.customer_type = "blank"
    @customer.due_date = nil
    assert @customer.valid?
  end

  test "last_charged should be present" do
    @customer.last_charged = nil
    assert_not @customer.valid?
  end

  test "last_charged not required if customer_type blank" do
    @customer.customer_type = "blank"
    @customer.last_charged = nil
    assert @customer.valid?
  end

  test "customer_type should be present" do
    @customer.customer_type = nil
    assert_not @customer.valid?
  end

  test "customer_type should be either blank or tenant" do
    @customer.customer_type = "blank"
    assert @customer.valid?
    @customer.customer_type = "tenant"
    assert @customer.valid?

    @customer.customer_type = "foo"
    assert_not @customer.valid?
  end

  test "after_create should set properties rented attribute to false" do
    customer = @customer.dup
    customer.property = properties(:two)
    customer.save
    assert_equal properties(:two).rented, true
  end

  test "payments for customer should be destroyed when customer is destroyed" do
    assert_difference 'Payment.count', -4 do
      @customer.destroy
    end
  end

  test "invoices for customer should be destroyed when customer is destoryed" do
    assert_difference 'Invoice.count', -1 do
      @customer.destroy
    end
  end

  test "enter rent should enter rent for the customer" do
    invoice = nil

    assert_difference ["Invoice.count", "AccountTran.count", "Tran.count"] do
      invoice = @customer.enter_rent
    end

    assert_equal invoice.amount, @customer.rent
    assert_equal invoice.memo, "Rent for #{Date::MONTHNAMES[Date.today.month]} #{Date.today.year}"
    assert_equal invoice.account_trans.count, 1
    assert_equal invoice.account_trans.first.account, accounts(:one)
  end

  test "setup_last_charged should add last_charged attr to customer" do
    @customer = @customer.dup
    @customer.last_charged = nil
    @customer.setup_last_charged
    assert_equal @customer.last_charged, Date.new(Date.today.year, Date.today.month, @customer.due_date.to_i)
  end

  test "charge_prorated_rent should charge entire rent on the first" do
    Timecop.freeze(Date.today.beginning_of_month) do
      assert_difference ["Invoice.count", "AccountTran.count", "Tran.count"] do
        rent = @customer.charge_prorated_rent
        assert_equal rent.amount, @customer.rent
      end
    end
  end

  test "charge_prorated_rent should charge prorated rent for any other day than the first" do
    Timecop.freeze(Date.today.beginning_of_year + 10) do
      assert_difference ["Invoice.count", "AccountTran.count", "Tran.count"] do
        rent = @customer.charge_prorated_rent
        assert_equal rent.amount, 338.71
      end
    end
  end

  test "prorated_rent where due_date != 1 test 1" do
    @customer.due_date = 20
    Timecop.freeze(Date.today.beginning_of_year + 1.month + 10.days) do
      assert_difference ["Invoice.count", "AccountTran.count", "Tran.count"] do
        rent = @customer.charge_prorated_rent
        per_day = @customer.rent / Date.today.end_of_month.day

        assert_equal rent.amount, (per_day * 9).round(2)
      end
    end
  end

  test "prorated_rent where due_date != 1 test 2" do
    @customer.due_date = 10

    Timecop.freeze(Date.today.beginning_of_year + 2.months + 4.days) do
      assert_difference ['Invoice.count', 'AccountTran.count', 'Tran.count'] do
        rent = @customer.charge_prorated_rent
        per_day = @customer.rent / Date.today.end_of_month.day

        # should be charged for 5 days
        assert_equal rent.amount, (per_day * 5).round(2)
      end
    end
  end

  test "prorated_rent rent next month test 1" do
    @customer.due_date = 5
    Timecop.freeze(Date.today.beginning_of_year + 2.month + 17.days) do
      assert_difference ["Invoice.count", "AccountTran.count", "Tran.count"] do
        rent = @customer.charge_prorated_rent
        amount_for_march = @customer.rent / Date.today.end_of_month.day
        amount_for_april = @customer.rent / (Date.today + 1.month).end_of_month.day

        # should be charge for 13 + 1 days in march, and 4 days in april
        assert_equal rent.amount, ((amount_for_march * 14) + (amount_for_april * 4)).round(2)
      end
    end
  end

  test "prorated_rent rent next month test 2" do
    @customer.due_date = 6

    Timecop.freeze(Date.today.beginning_of_year + 3.month + 11.days) do
      assert_difference ["Invoice.count", "AccountTran.count", "Tran.count"] do
        rent = @customer.charge_prorated_rent
        amount_for_april = @customer.rent / Date.today.end_of_month.day
        amount_for_may = @customer.rent / (Date.today + 1.month).end_of_month.day

        # should be charged for 18 + 1 days in april and 5 day for may
        assert_equal rent.amount, ((amount_for_april * 19) + (amount_for_may * 5)).round(2)
      end
    end
  end

  test "update last charged should update last_charged for updated due date" do
    @customer.last_charged = Date.today.beginning_of_month
    @customer.due_date = "12"
    @customer.update_last_charged
    assert_equal @customer.last_charged, Date.today.beginning_of_month + 11
  end

  test "full_name should return full_name for customer" do
    assert_equal @customer.full_name, "Foo Test Blah"
  end

  test "full_name should return company name if first and last name don't exist" do
    @customer.first_name = "   "
    @customer.middle_name = ""
    @customer.last_name = ""
    @customer.company_name = "foobar"

    assert_equal @customer.full_name, "foobar"
  end

  test "archive should archive customer" do
    @customer.archive
    assert_not @customer.active
    assert_not @customer.property.rented?
  end

  test "archive should credit customer for balance if it is greater than zero" do
    @customer.balance = 500
    credit = nil

    assert_difference ['Credit.count', 'AccountTran.count', 'Tran.count'] do
      credit = @customer.archive
    end
    account_tran = credit.account_trans.first

    assert_equal credit.user, @customer.user
    assert_equal credit.amount, 500
    assert_equal credit.date, Date.today
    assert_equal credit.memo, "Write off remaining balance"

    assert_equal credit.account_trans.length, 1
    assert_equal account_tran.user, @customer.user
    assert_equal account_tran.account, accounts(:one)
    assert_equal account_tran.account_transable, credit
    assert_equal account_tran.amount, -500
  end

  test "archive should work for blank customers" do
    customer = customers(:blank)
    customer.balance = 500
    credit = nil

    assert_difference ['Credit.count', 'AccountTran.count', 'Tran.count'] do
      credit = customer.archive
    end
    account_tran = credit.account_trans.first

    assert_not customer.active

    assert_equal credit.user, @customer.user
    assert_equal credit.amount, 500
    assert_equal credit.date, Date.today
    assert_equal credit.memo, "Write off remaining balance"

    assert_equal credit.account_trans.length, 1
    assert_equal account_tran.user, @customer.user
    assert_equal account_tran.account, accounts(:one)
    assert_equal account_tran.account_transable, credit
    assert_equal account_tran.amount, -500
  end

  test "is_blank should return true if customer_type is 'blank'" do
    @customer.customer_type = "blank"
    assert @customer.is_blank?
  end

  test "grab_trans should return either payments or all trans depending on display param" do
    assert_equal customers(:one).grab_trans('payments').count, 4
    assert_equal customers(:one).grab_trans.count, 4
    assert_equal customers(:one).grab_trans('all').count, 6
    assert_equal customers(:one).grab_trans('foobar').count, 6
  end

  test "grab_all should return all customers or active customers only depending on display param" do
    assert_equal Customer.grab_all(users(:one), 'active').count, 2
    assert_equal Customer.grab_all(users(:one)).count, 2
    assert_equal Customer.grab_all(users(:one), 'all').count, 3
  end
end
