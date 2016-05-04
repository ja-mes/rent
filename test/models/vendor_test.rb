require 'test_helper'

class VendorTest < ActiveSupport::TestCase
  def setup
    @vendor = vendors(:one)
  end

  test "should be valid" do
    assert @vendor.valid?
  end

  test "user should be present" do
    @vendor.user_id = nil
    assert_not @vendor.valid?
  end

  test "name should be present" do
    @vendor.name = nil
    assert_not @vendor.valid?
  end

end
