class CreateInvoiceTrans < ActiveRecord::Migration
  def change
    create_table :invoice_trans do |t|
      t.decimal :amount
      t.string :memo

      t.timestamps null: false
    end
  end
end
