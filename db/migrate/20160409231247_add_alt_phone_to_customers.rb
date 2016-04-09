class AddAltPhoneToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :alt_phone, :string
  end
end
