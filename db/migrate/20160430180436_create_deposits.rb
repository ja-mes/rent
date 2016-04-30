class CreateDeposits < ActiveRecord::Migration
  def change
    create_table :deposits do |t|
      t.integer :user_id
      t.decimal :amount

      t.timestamps null: false
    end
  end
end
