class AddInvoiceIdToInvoiceTrans < ActiveRecord::Migration
  def change
    add_column :invoice_trans, :invoice_id, :integer
  end
end
