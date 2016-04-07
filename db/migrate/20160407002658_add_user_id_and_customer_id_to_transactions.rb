class AddUserIdAndCustomerIdToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :user_id, :integer
    add_column :transactions, :customer_id, :integer
  end
end
