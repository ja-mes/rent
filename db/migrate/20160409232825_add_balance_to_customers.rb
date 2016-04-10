class AddBalanceToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :balance, :decimal
  end
end
