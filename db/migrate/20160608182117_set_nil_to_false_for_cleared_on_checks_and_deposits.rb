class SetNilToFalseForClearedOnChecksAndDeposits < ActiveRecord::Migration
  def change
    change_column :checks, :cleared, :boolean, :default => false, :null => false 
    change_column :deposits, :cleared, :boolean, :default => false, :null => false 
  end
end
