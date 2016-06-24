require 'test_helper'

class PropertyTest < ActiveSupport::TestCase
  def setup
    @property = properties(:one)
  end

  test "property should be valid" do
    assert @property.valid?
  end

  test "property should have customers" do
    assert_not_nil @property.customers
  end

  test "property should still be valid without customers" do
    @property.customers = [] 
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

  test "deposit should be a number" do
    @property.deposit = "foo"
    assert_not @property.valid?
  end

  test "deposit should be greater than zero" do
    @property.deposit = -4.50
    assert_not @property.valid?
  end


  test "full address should return full address for property" do
    assert_equal @property.full_address, "#{@property.address}, #{@property.city}, #{@property.state} #{@property.zip}"
  end
end
