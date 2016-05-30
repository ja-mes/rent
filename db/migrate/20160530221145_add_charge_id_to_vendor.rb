class AddChargeIdToVendor < ActiveRecord::Migration
  def change
    add_column :recurring_trans, :charge_id, :integer
  end
end
