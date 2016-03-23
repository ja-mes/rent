class AddDepositAndRentToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :rent, :decimal
    add_column :properties, :deposit, :decimal
  end
end
