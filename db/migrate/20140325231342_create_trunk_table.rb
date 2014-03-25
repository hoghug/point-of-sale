class CreateTrunkTable < ActiveRecord::Migration
  def change
    create_table :trunks do |t|
      t.belongs_to :purchase
      t.belongs_to :product
    end
  end
end
