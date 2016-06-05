class RemoveDescriptionFromRecurringTrans < ActiveRecord::Migration
  def change
    remove_column :recurring_trans, :description, :string
  end
end
