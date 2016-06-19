class RemoveCustomerTypeFromCustomers < ActiveRecord::Migration
  def change
    remove_column :customers, :customer_type, :string
  end
end
