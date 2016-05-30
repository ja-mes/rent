class AddDueDateToRecurringTrans < ActiveRecord::Migration
  def change
    add_column :recurring_trans, :due_date, :date
  end
end
