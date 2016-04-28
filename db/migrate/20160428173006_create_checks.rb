class CreateChecks < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.integer :user_id
      t.integer :num
      t.date :date
      t.decimal :amount
      t.string :memo

      t.timestamps null: false
    end
  end
end
