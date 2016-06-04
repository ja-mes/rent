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

  test "first_name should be present" do
    @customer.first_name = " "
    assert_not @customer.valid?
  end

  test "last_name should be present" do
    @customer.last_name = " "
    assert_not @customer.valid?
  end

  test "full_name should return full_name for customer" do
    assert_equal @customer.full_name, "Foo Test Blah"
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


  test "archive should archive customer" do
    @customer.archive
    assert_not @customer.active
    assert_not @customer.property.rented?
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

  test "after_create should set properties rented attribute to false" do
    customer = @customer.dup
    customer.property = properties(:two)
    customer.save
    assert_equal properties(:two).rented, true
  end
end
