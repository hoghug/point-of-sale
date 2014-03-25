class BigChanges < ActiveRecord::Migration
  def change
    drop_table :carts
    add_column :products, :customer_id, :integer

  end
end
