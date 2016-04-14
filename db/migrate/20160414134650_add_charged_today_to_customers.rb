class AddChargedTodayToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :charged_today, :bool, null: false, default: false
  end
end
