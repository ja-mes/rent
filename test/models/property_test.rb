require 'test_helper'

class PropertyTest < ActiveSupport::TestCase
  def setup
    @obj = { address: "100 Foo St.", state: "AL", city: "Boaz", zip: "35956", rent: 500, deposit: 300, customer: customers(:one), rented: true }
    @property = Property.new(@obj)
    @property.user = users(:one)
  end

  test "property should be valid" do
    assert @property.valid?
  end

  test "property should have a customer" do
    assert_not_nil @property.customer
  end

  test "rented should be false if customer is not rented" do
    assert @property.rented
  end

  test "property should still be valid without a customer" do
    @property.customer = nil
    assert @property.valid?
  end

  test "user should be present" do
    @property.user = nil
    assert_not @property.valid?
  end

  test "address should be present" do
    @property.address = "  "
    assert_not @property.valid?
  end

  test "address should be unique" do
    @property.save
    @property2 = Property.new(@obj)
    assert_not @property2.valid?
  end

  test "state should be present" do
    @property.state = " "
    assert_not @property.valid?
  end

  test "state length should not be greater than 2" do
    @property.state = "AAA"
    assert_not @property.valid?
  end

  test "state length should not be less than 2" do
    @property.state = "A"
    assert_not @property.valid?
  end

  test "state should be upcased before saved" do
    @property.state = "al"
    @property.save
    assert_equal @property.state, "AL", "it didn't work"
  end

  test "city should be present" do
    @property.city = " "
    assert_not @property.valid?
  end

  test "zip should be present" do
    @property.zip = " "
    assert_not @property.valid?
  end

  test "rent should be present" do
    @property.rent = nil
    assert_not @property.valid?
  end

  test "rent should be a number" do
    @property.rent = "foo"
    assert_not @property.valid?
  end

  test "rent should be greater than zero" do
    @property.rent = -5.25
    assert_not @property.valid?
  end

  test "deposit should be present" do
    @property.deposit = nil
    assert_not @property.valid?
  end

  test "deposit should be a number" do
    @property.deposit = "foo"
    assert_not @property.valid?
  end

  test "deposit should be greater than zero" do
    @property.deposit = -4.50
    assert_not @property.valid?
  end
end
