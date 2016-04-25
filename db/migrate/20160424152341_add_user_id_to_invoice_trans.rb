class AddUserIdToInvoiceTrans < ActiveRecord::Migration
  def change
    add_column :invoice_trans, :user_id, :integer
  end
end
