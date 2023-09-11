class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :children, class_name: "Category", foreign_key: "parent_id"
end
