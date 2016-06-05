class AddLastEntryDateToRecurringTrans < ActiveRecord::Migration
  def change
    add_column :recurring_trans, :last_entry, :date
  end
end
