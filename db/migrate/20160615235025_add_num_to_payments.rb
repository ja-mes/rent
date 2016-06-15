class AddNumToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :num, :string
  end
end
