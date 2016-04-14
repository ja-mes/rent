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
    results = Customer.search('Foo', users(:one))
    assert_equal 1, Customer.search('Foo', users(:one)).length
    assert_equal 1, Customer.search('Foo Blah', users(:one)).length
    assert_equal 1, Customer.search('Foo Test Blah', users(:one)).length
    assert_equal 1, Customer.search('Foo Test', users(:one)).length
  end
end
