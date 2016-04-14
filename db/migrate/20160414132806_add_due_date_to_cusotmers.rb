class AddDueDateToCusotmers < ActiveRecord::Migration
  def change
    add_column :customers, :due_date, :date
  end
end
