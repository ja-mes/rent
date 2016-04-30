class AddAccountIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :account_id, :integer
  end
end
