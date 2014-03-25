class RenameCartColumns < ActiveRecord::Migration
  def change
    rename_column(:carts, :customer_id_id, :customer_id)
    rename_column(:carts, :product_id_id, :product_id)
  end
end
