class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :address
      t.string :state
      t.string :city
      t.string :zip
    end
  end
end
