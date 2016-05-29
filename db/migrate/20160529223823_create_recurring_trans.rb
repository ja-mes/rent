class CreateRecurringTrans < ActiveRecord::Migration
  def change
    create_table :recurring_trans do |t|
      t.integer :user_id
      t.decimal :amount

      t.timestamps null: false
    end
  end
end
