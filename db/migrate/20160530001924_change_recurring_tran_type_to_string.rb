class ChangeRecurringTranTypeToString < ActiveRecord::Migration
  def change
    change_column :recurring_trans, :due_date, :string
  end
end
