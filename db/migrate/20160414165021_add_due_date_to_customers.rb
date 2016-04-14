class AddDueDateToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :due_date, :string
  end
end
