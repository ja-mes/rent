class RemoveDueDateFromCustomers < ActiveRecord::Migration
  def change
    remove_column :customers, :due_date
  end
end
