class Order < ApplicationRecord
  belongs_to :user
  has_many :order_details, dependent: :destroy

  enum status: {awaiting: 1, confirmed: 2, canceled: 3}

  validates :reciver_name, presence: true,
    length: {maximum: Settings.orders.length_30}
  validates :reciver_address, presence: true,
    length: {maximum: Settings.orders.length_50}
  validates :reciver_phone, presence: true,
    format: {with: Settings.orders.regex}
end
