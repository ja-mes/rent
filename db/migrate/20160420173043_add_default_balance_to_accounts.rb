class AddDefaultBalanceToAccounts < ActiveRecord::Migration
  def change
    change_column_default :accounts, :balance, 0.00
  end
end
