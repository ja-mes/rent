class SetDefaultValueForRegisterBalance < ActiveRecord::Migration
  def change
    change_column :registers, :balance, :decimal, default: 0, null: 0
  end
end
