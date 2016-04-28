class RenameInvoiceTrans < ActiveRecord::Migration
  def change
    rename_table :invoice_trans, :account_trans
  end
end
