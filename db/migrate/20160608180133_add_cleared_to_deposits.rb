class AddClearedToDeposits < ActiveRecord::Migration
  def change
    add_column :deposits, :cleared, :boolean
  end
end
