class AddCart < ActiveRecord::Migration
  def change
    create_table :cart do |t|
      t.belongs_to :customer_id
      t.belongs_to :product_id
    end
  end
end
