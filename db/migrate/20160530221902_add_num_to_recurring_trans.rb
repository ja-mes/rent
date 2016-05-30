class AddNumToRecurringTrans < ActiveRecord::Migration
  def change
    add_column :recurring_trans, :num, :integer
  end
end
