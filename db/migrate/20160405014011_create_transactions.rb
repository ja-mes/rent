class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :transactionable, polymorphic: true
    end
  end
end
