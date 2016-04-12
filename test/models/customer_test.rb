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

  test "full_name should be unique" do
    @customer.save
    @customer2 = Customer.new(
      first_name: "Foo",
      last_name: "Blah",
      middle_name: "Test",
      phone: "(123)456-7891",
      full_name: "Foo Test Blah",
      property: properties(:one),
      user: users(:one),
    )
    assert_not @customer2.valid?
  end
end
