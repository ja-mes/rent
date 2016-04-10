class AddDefaultValueForCustomerBalance < ActiveRecord::Migration
  def change
    change_column_default :customers, :balance, 0.00
  end
end
