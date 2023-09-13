class Feedback < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :content, presence: true,
    length: {maximum: Settings.orders.length_30}

  validates :rating, presence: true

  scope :filter_by_product_id, lambda {|product_id|
    where(product_id:)
  }
end
