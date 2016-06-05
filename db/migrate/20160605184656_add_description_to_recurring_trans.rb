class AddDescriptionToRecurringTrans < ActiveRecord::Migration
  def change
    add_column :recurring_trans, :description, :string
  end
end
