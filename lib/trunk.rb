class Trunk < ActiveRecord::Base
  has_and_belongs_to_many :products
  has_and_belongs_to_many :purchases
end
