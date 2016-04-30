class AddDateToAccountTrans < ActiveRecord::Migration
  def change
    add_column :account_trans, :date, :date
  end
end
