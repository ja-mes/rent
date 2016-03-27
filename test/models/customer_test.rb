class CustomerTest < ActiveSupport::TestCase
  def setup
    @obj = {
      first_name: "Foo",
      last_name: "Blah",
      middle_name: "Test",
      phone: "(123)456-7891",
      full_name: "Foo Test Blah",
    }

    @customer = Customer.new(@obj)
    @customer.user = users(:one)
  end

  test "customer should be valid" do
    assert @customer.valid?
  end

  test "first_name should be present" do
    @customer.first_name = " "
    assert_not @customer.valid?
  end

  test "last_name should be present" do
    @customer.last_name = " "
    assert_not @customer.valid?
  end

  test "full_name should be present" do
    @customer.full_name = " "
    assert_not @customer.valid?
  end
end
