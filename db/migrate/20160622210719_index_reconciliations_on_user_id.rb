class IndexReconciliationsOnUserId < ActiveRecord::Migration
  def change
    add_index :reconciliations, :user_id
  end
end
