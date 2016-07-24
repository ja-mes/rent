class AddMoreFieldsToVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :city, :string
    add_column :vendors, :state, :string
    add_column :vendors, :zip, :string
  end
end
