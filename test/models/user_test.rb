require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  test "vacant_properties should return vacant properties for the user" do
    assert_equal @user.vacant_properties.count, 1
  end

  test "grab_trans should return transactions for the specified customer" do
    assert @user.grab_trans(customers(:one))
  end

  test "after create should add default accounts" do
    assert_difference 'Account.count', 7 do
      @user = User.create(:email => 'never_before_used_email_address@blah.com', :password => 'password', :password_confirmation => 'password')
    end

    accounts = @user.accounts.limit(6)

    assert_equal @user.accounts[0].name, "Rental Income"
    assert_equal @user.accounts[1].name, "Checking"
    assert_equal @user.accounts[2].name, "Security Deposits"
    assert_equal @user.accounts[3].name, "Undeposited Funds"
    assert_equal @user.accounts[4].name, "Deposit Discrepancies"
    assert_equal @user.accounts[5].name, "Reconciliation Discrepancies"
    assert_equal @user.accounts[6].name, "Repairs and Maintenance"
  end

end
