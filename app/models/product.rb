class Product < ApplicationRecord
  belongs_to :category
  has_one_attached :image
  scope :sort_by_name, ->{order :name}
end
