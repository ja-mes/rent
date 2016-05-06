class AddCustomerIdToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :customer_id, :integer
  end
end
