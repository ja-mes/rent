class RemoveClearedBalanceFromReconciliations < ActiveRecord::Migration
  def change
    remove_column :reconciliations, :cleared_balance, :decimal
  end
end
