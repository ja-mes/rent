class RemoveAccountTypeFromAccounts < ActiveRecord::Migration
  def change
    remove_column :accounts, :account_type, :string
  end
end
