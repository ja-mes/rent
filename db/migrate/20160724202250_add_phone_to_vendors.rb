class AddPhoneToVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :phone, :string
  end
end
