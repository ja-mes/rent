class AddLastChargedToRecurringTrans < ActiveRecord::Migration
  def change
    add_column :recurring_trans, :last_charged, :date
  end
end
