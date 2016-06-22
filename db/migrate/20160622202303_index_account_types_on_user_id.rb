class IndexAccountTypesOnUserId < ActiveRecord::Migration
  def change
    add_index :account_types, :user_id
  end
end
