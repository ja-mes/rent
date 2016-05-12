class AddIncToAccountTrans < ActiveRecord::Migration
  def change
    add_column :account_trans, :inc, :bool
  end
end
