class AddInternalToProperties < ActiveRecord::Migration[5.0]
  def change
    add_column :properties, :internal, :bool, default: false, null: false
  end
end
