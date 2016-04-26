class AddPropertyIdToInvoiceTrans < ActiveRecord::Migration
  def change
    add_column :invoice_trans, :property_id, :integer
  end
end
