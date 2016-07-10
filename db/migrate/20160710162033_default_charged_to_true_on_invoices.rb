class DefaultChargedToTrueOnInvoices < ActiveRecord::Migration[5.0]
  def change
    change_column :invoices, :charged, :boolean, default: true, null: true
  end
end
