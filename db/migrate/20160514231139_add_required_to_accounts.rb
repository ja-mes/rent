class AddRequiredToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :required, :bool, default: false
  end
end
