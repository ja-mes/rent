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

  test "update last charged should update last_charged for updated due date" do
    @customer.last_charged = Date.today.beginning_of_month
    @customer.due_date = "12"
    @customer.update_last_charged
    assert_equal @customer.last_charged, Date.today.beginning_of_month + 11
  end

  test "search should find customers by the specified search" do
    assert_equal 1, Customer.search('Foo', nil, users(:one)).length
    assert_equal 1, Customer.search('Foo Blah', nil, users(:one)).length
    assert_equal 1, Customer.search('Foo Test Blah', nil, users(:one)).length
    assert_equal 1, Customer.search('Foo Test', nil, users(:one)).length
  end

  test "search should find either active or all customers depending on search param" do
    assert_equal 1, Customer.search('Foo', nil, users(:one)).length
    assert_equal 0, Customer.search('First Last', 'active', users(:one)).length
    assert_equal 1, Customer.search('First Last', 'all', users(:one)).length
    assert_equal 0, Customer.search('First Middle', 'active', users(:one)).length
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

  test "is_blank should return true if customer_type is 'blank'" do
    @customer.customer_type = "blank"
    assert @customer.is_blank?
  end
end
