class InitialTables < ActiveRecord::Migration
  def change
    create_table :cashiers do |t|
      t.column :name, :string
    end

    create_table :customers do |t|
      t.column :name, :string
    end

    create_table :statuses do |t|
      t.column :name, :string
    end

    create_table :products do |t|
      t.column :name, :string
      t.column :price, :decimal
      t.belongs_to :status
    end

    create_table :purchases do |t|
      t.belongs_to :customer
      t.belongs_to :cashier
      t.timestamps
      # t.column :customer_id, :integer
      # t.column :cashier_id, :integer
    end

    create_table :products_purchases do |t|
      t.belongs_to :purchase
      t.belongs_to :product
      t.column :qty, :integer
      # t.column :purchase_id, :integer
      # t.column :product_id, :integer
    end

  end
end
