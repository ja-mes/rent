class CreateAccountTypes < ActiveRecord::Migration
  def change
    create_table :account_types do |t|
      t.integer :user_id
      t.string :name
      t.boolean :inc

      t.timestamps null: false
    end
  end
end
