class RemoveAccountIdFromPayments < ActiveRecord::Migration
  def change
    remove_column :payments, :account_id, :integer
  end
end
