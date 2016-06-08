class AddClearedToChecks < ActiveRecord::Migration
  def change
    add_column :checks, :cleared, :boolean
  end
end
