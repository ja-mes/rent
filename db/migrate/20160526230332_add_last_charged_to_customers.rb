class AddLastChargedToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :last_charged, :date
  end
end
