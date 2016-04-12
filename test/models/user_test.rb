require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  test "vacant_properties should return vacant properties for the user" do
    assert_equal @user.vacant_properties.count, 1
  end

  test "grab_trans should return transactions for the specified customer" do
    assert_equal @user.grab_trans(customers(:one)).count, 2
  end
end
