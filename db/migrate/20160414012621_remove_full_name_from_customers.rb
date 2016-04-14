class RemoveFullNameFromCustomers < ActiveRecord::Migration
  def change
    remove_column :customers, :full_name
  end
end
