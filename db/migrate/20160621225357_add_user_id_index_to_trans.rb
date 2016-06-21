class AddUserIdIndexToTrans < ActiveRecord::Migration
  def change
    add_index :trans, :user_id
  end
end
