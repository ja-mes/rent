class IndexCreditsOnUserId < ActiveRecord::Migration
  def change
    add_index :credits, :user_id
  end
end
