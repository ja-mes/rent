class AddClearedBalanceToReconcilitions < ActiveRecord::Migration
  def change
    add_column :reconciliations, :cleared_balance, :decimal, default: 0
  end
end
