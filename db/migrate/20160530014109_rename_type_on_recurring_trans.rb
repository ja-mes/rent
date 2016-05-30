class RenameTypeOnRecurringTrans < ActiveRecord::Migration
  def change
    rename_column :recurring_trans, :type, :tran_type
  end
end
