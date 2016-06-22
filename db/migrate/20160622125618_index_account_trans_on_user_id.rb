class IndexAccountTransOnUserId < ActiveRecord::Migration
  def change
    add_index :account_trans, :user_id
  end
end
