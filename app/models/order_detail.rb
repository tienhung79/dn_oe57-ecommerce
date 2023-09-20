class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product

  delegate :name, :image, :price, to: :product, prefix: true
end
