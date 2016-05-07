class AddDiscrepanciesToDeposits < ActiveRecord::Migration
  def change
    add_column :deposits, :discrepancies, :decimal
  end
end
