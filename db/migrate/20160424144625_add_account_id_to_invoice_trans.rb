class AddAccountIdToInvoiceTrans < ActiveRecord::Migration
  def change
    add_column :invoice_trans, :account_id, :integer
  end
end
