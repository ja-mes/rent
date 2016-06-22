class RemoveBlankCustome < ActiveRecord::Migration
  def change
    drop_table :blank_customers
  end
end
