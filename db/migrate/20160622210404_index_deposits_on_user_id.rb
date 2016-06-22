class IndexDepositsOnUserId < ActiveRecord::Migration
  def change
    add_index :deposits, :user_id
  end
end
