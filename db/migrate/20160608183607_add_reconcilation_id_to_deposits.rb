class AddReconcilationIdToDeposits < ActiveRecord::Migration
  def change
    add_column :deposits, :reconciliation_id, :integer
  end
end
