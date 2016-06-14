class AddInternalToDeposits < ActiveRecord::Migration
  def change
    add_column :deposits, :internal, :bool, default: false, nul: false
  end
end
