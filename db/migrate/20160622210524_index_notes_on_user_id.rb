class IndexNotesOnUserId < ActiveRecord::Migration
  def change
    add_index :notes, :user_id
  end
end
