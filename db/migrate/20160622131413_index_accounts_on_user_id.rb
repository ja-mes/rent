class IndexAccountsOnUserId < ActiveRecord::Migration
  def change
    add_index :accounts, :user_id
  end
end
