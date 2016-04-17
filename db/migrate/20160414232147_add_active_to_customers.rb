class AddActiveToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :active, :bool, null: false, default: true
  end
end
