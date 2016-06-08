class SetDefaultValueToFalseOnClearedInChecksAndDeposits < ActiveRecord::Migration
  def change
    change_column :checks, :cleared, :boolean, :default => false
    change_column :deposits, :cleared, :boolean, :default => false
  end
end
