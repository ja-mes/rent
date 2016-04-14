class RemoveFirstNameFromCustomers < ActiveRecord::Migration
  def change
    remove_column :customers, :first_name
  end
end
