class AddAccountTranTypeToAccountTrans < ActiveRecord::Migration
  def change
    add_column :account_trans, :account_tran_type, :integer
  end
end
