class RemoveLastChargedFromCustomers < ActiveRecord::Migration
  def change
    remove_column :customers, :last_charged, :date
  end
end
