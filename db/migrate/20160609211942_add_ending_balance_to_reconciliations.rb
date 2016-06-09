class AddEndingBalanceToReconciliations < ActiveRecord::Migration
  def change
    add_column :reconciliations, :ending_balance, :decimal
  end
end
