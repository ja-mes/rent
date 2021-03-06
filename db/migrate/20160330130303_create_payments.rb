class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.integer :customer_id
      t.decimal :amount
      t.date :date
      t.string :memo
    end
  end
end
