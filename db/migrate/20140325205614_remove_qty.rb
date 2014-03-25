class RemoveQty < ActiveRecord::Migration
  def change
    remove_column :products_purchases, :qty, :integer
  end
end
