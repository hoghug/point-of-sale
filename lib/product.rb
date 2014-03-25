class Product < ActiveRecord::Base
  has_and_belongs_to_many :purchases
  belongs_to :statuses

end
