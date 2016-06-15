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


  test "create_default_accounts should create default accounts" do
    @user.accounts.destroy_all
    assert_difference 'Account.count', 7 do
      @user.create_default_accounts
    end


    @user.registers.destroy_all
    assert_difference 'Register.count', 1 do
      @user.create_default_accounts
    end

    @user.account_types.destroy_all
    assert_difference 'AccountType.count', 6 do
      @user.create_default_accounts
    end
  end
end
