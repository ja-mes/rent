class AddFutureDatesToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :future_dates, :date, array: true
  end
end
