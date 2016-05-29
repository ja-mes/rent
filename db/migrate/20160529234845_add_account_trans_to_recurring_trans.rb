class AddAccountTransToRecurringTrans < ActiveRecord::Migration
  def change
    add_column :recurring_trans, :account_trans, :hstore, array: true
  end
end
