class AddVendorIdToChecks < ActiveRecord::Migration
  def change
    add_column :checks, :vendor_id, :integer
  end
end
