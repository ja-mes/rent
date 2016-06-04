class RemoveChargedTodayFromCustomers < ActiveRecord::Migration
  def change
    remove_column :customers, :charged_today, :bool
  end
end
