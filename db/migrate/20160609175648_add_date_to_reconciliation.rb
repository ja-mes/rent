class AddDateToReconciliation < ActiveRecord::Migration
  def change
    add_column :reconciliations, :date, :date
  end
end
