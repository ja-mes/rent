class CreateReconciliations < ActiveRecord::Migration
  def change
    create_table :reconciliations do |t|
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
