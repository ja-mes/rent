class AddNameAndBalanceToRegister < ActiveRecord::Migration
  def change
    add_column :registers, :name, :string
    add_column :registers, :balance, :decimal
  end
end
