class AddRentAmountToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :rent, :decimal
  end
end
