require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  def work_account(fixture, method_name)
    assert_equal fixture, users(:one).send(method_name)

    fixture.destroy

    assert_difference "#{fixture.class.name}.count" do
      users(:one).send(method_name)
    end
  end

  test "vacant_properties should return vacant properties for the user" do
    assert_equal @user.vacant_properties.count, 1
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

  test "checkbook should find or create checking register" do
    checkbook = registers(:one)
    assert_equal users(:one).checkbook, checkbook

    checkbook.destroy

    assert_difference 'Register.count' do
      users(:one).checkbook
    end
  end

  test "income_account_type" do
    work_account(account_types(:income), 'income_account_type')
  end

  test "bank_account_type" do
    work_account(account_types(:bank), 'bank_account_type')
  end

  test "other_current_assets_account_type" do
    work_account(account_types(:other_current_assets), 'other_current_assets_account_type')
  end

  test "other_current_liabilities_account_type" do
    work_account(account_types(:other_current_liabilities), 'other_current_liabilities_account_type')
  end

  test "other_income_account_type" do
    work_account(account_types(:other_income), 'other_income_account_type')
  end

  test "expenses_account_type" do
    work_account(account_types(:expenses), 'expenses_account_type')
  end


  # accounts
  test "rental_income_account" do
    work_account(accounts(:one), 'rental_income_account')
  end

  test "security_deposits_account" do
    work_account(accounts(:three), 'security_deposits_account')
  end

  test "undeposited_funds_account" do
    work_account(accounts(:five), 'undeposited_funds_account')
  end

  test "deposit_discrepancies_account" do
    work_account(accounts(:six), 'deposit_discrepancies_account')
  end

  test "reconciliaton_discrepancies_account" do
    work_account(accounts(:reconcile_discrepancies), 'reconciliaton_discrepancies_account')
  end

  test "repairs_and_maintenance_account" do
    work_account(accounts(:repairs), 'repairs_and_maintenance_account')
  end
end
