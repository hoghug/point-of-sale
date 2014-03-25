class Purchase < ActiveRecord::Base
  has_and_belongs_to_many :products
  belongs_to :cashiers
  belongs_to :customers
end
