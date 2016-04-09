class RenameTransactions < ActiveRecord::Migration
  def change
    rename_table :transactions, :trans
  end
end
