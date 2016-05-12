class RemoveIncFromAccountTrans < ActiveRecord::Migration
  def change
    remove_column :account_trans, :inc, :bool
  end
end
