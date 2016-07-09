class DefaultChargedOnInvoicesToFalse < ActiveRecord::Migration[5.0]
  def change
    change_column :invoices, :charged, :bool, default: false, null: false
  end
end
