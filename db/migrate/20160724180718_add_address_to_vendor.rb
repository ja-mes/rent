class AddAddressToVendor < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :address, :string
  end
end
