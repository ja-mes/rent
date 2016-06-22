class IndexRecurringTransOnUserId < ActiveRecord::Migration
  def change
    add_index :recurring_trans, :user_id
  end
end
