class AddRentedToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :rented, :string
  end
end
