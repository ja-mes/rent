class AddBalanceToChecks < ActiveRecord::Migration[5.0]
  def change
    add_column :checks, :balance, :decimal
  end
end
