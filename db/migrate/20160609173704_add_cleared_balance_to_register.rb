class AddClearedBalanceToRegister < ActiveRecord::Migration
  def change
    add_column :registers, :cleared_balance, :decimal, default: 0
  end
end
