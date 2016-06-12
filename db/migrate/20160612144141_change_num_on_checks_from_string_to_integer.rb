class ChangeNumOnChecksFromStringToInteger < ActiveRecord::Migration
  def change
    change_column :checks, :num, :string
  end
end
