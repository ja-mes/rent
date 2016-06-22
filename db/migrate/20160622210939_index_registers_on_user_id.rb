class IndexRegistersOnUserId < ActiveRecord::Migration
  def change
    add_index :registers, :user_id
  end
end
