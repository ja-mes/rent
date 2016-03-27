class AddRentedToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :rented, :boolean, default: false
  end
end
