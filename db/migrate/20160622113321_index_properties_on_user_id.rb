class IndexPropertiesOnUserId < ActiveRecord::Migration
  def change
    add_index :properties, :user_id
  end
end
