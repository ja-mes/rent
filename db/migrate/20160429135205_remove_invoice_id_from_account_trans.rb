class RemoveInvoiceIdFromAccountTrans < ActiveRecord::Migration
  def change
    remove_column :account_trans, :invoice_id
  end
end
