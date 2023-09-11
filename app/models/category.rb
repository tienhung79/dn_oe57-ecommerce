class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  scope :child_categories, -> { where.not parent_id: nil }
end
