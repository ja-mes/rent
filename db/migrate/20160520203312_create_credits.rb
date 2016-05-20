class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.integer :user_id
      t.decimal :amount
      t.integer :customer_id
      t.date :date
      t.string :memo

      t.timestamps null: false
    end
  end
end
