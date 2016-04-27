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


  test "after_find should create invoice and only do it once" do
    @customer.due_date = Date.today.day.to_s
    @customer.save

    assert_difference ['Invoice.count', 'InvoiceTran.count'] do
      customer = Customer.find(@customer.id)
      assert customer.charged_today?
    end

    assert_difference ['Invoice.count', 'InvoiceTran.count'], 0 do
      Customer.find(@customer.id)
    end
  end

  test "after_find should only create invoice if this is the due date" do
    @customer.due_date = (Date.today.day.to_i - 1).to_s
    @customer.charged_today = true
    @customer.save

    assert_difference 'Invoice.count', 0 do
      customer = Customer.find(@customer.id)
      assert_not customer.charged_today
    end
  end

  test "archive should archive customer" do
    @customer.archive
    assert_not @customer.active
    assert_not @customer.property.rented?
  end
end
