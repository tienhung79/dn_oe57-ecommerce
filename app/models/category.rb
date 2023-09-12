class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :childrens, class_name: Category.name, foreign_key: :parent_id,
    dependent: :destroy
  belongs_to :parent, class_name: Category.name, optional: true
  scope :parent_items, ->{where parent_id: nil}
  scope :children_of, lambda {|parent_items|
                        where(parent_id: parent_items.pluck(:id))
                      }
end
