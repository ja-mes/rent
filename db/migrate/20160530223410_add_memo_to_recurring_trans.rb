class AddMemoToRecurringTrans < ActiveRecord::Migration
  def change
    add_column :recurring_trans, :memo, :string
  end
end
