class AddPropertyIdToCustomerAndCustomerIdToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :customer_id, :integer
    add_column :customers, :property_id, :integer
  end
end
