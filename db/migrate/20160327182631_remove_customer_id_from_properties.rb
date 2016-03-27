class RemoveCustomerIdFromProperties < ActiveRecord::Migration
  def change
    remove_column :properties, :customer_id, :integer
  end
end
