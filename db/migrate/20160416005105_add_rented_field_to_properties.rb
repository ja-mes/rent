class AddRentedFieldToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :rented, :bool, default: false, null: false
  end
end
