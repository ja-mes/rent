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

  test "after create should add default accounts" do
    assert_difference 'Account.count', 2 do
      @user = User.create(:email => 'never_before_used_email_address@blah.com', :password => 'password', :password_confirmation => 'password')
    end
    assert_equal @user.accounts.first.name, "Rental Income"
    assert_equal @user.accounts.last.name, "Deposits"
  end
end
