class IndexChecksOnUserId < ActiveRecord::Migration
  def change
    add_index :checks, :user_id
  end
end
