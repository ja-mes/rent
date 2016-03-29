class RemoveRentedFromProperties < ActiveRecord::Migration
  def change
    remove_column :properties, :rented, :boolean
  end
end
