class AddCustomerTypeFromCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :customer_type, :string, default: "tenant", null: "tenant"
  end
end
