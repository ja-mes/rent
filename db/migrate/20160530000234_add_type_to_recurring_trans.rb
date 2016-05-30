class AddTypeToRecurringTrans < ActiveRecord::Migration
  def change
    add_column :recurring_trans, :type, :string
  end
end
