class Cashier < ActiveRecord::Base
  has_many :purchases
  has_many :customers, through: :purchases
end
