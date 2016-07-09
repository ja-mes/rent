class AddChargedToInvoices < ActiveRecord::Migration[5.0]
  def change
    add_column :invoices, :charged, :boolean
  end
end
