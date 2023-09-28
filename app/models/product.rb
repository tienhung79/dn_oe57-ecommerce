class Product < ApplicationRecord
  belongs_to :category
  has_one_attached :image

  delegate :name, to: :category, prefix: true

  scope :sort_by_name, ->{order :name}
  scope :search_by_name, lambda {|name|
                           where("name LIKE ?", "%#{name}%")
                         }
  scope :filter_by_category_id, lambda {|category_id|
                                  where(category_id:)
                                }
  scope :find_id, lambda {|id|
                    where(id:)
                  }
  def self.ransackable_attributes _auth_object = nil
    %w(name description)
  end
end
