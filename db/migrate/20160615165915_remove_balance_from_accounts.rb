class RemoveBalanceFromAccounts < ActiveRecord::Migration
  def change
    remove_column :accounts, :balance, :decimal
  end
end
