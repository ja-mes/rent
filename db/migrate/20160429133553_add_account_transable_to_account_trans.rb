class AddAccountTransableToAccountTrans < ActiveRecord::Migration
  def change
    add_reference :account_trans, :account_transable, polymorphic: true
  end
end
