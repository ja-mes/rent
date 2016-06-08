class AddReconcilationIdToChecks < ActiveRecord::Migration
  def change
    add_column :checks, :reconciliation_id, :integer
  end
end
