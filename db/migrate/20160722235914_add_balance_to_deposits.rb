class AddBalanceToDeposits < ActiveRecord::Migration[5.0]
  def change
    add_column :deposits, :balance, :decimal
  end
end
