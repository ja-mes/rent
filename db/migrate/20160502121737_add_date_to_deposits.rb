class AddDateToDeposits < ActiveRecord::Migration
  def change
    add_column :deposits, :date, :date
  end
end
