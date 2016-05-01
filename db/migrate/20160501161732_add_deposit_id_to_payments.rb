class AddDepositIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :deposit_id, :integer
  end
end
