class DropAccountTranTypes < ActiveRecord::Migration
  def change
    drop_table :account_tran_types
  end
end
