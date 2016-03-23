require 'test_helper'

class PropertyTest < ActiveSupport::TestCase
  def setup
    @property = Property.new(address: "100 Foo St.", state: "AL", city: "Boaz", zip: "35956", rent: 500, deposit: 300)
    @property.user = users(:one)
  end

  test "property should be valid" do
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

end
