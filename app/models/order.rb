class Order < ApplicationRecord
  belongs_to :user

  validates :reciver_name, presence: true,
    length: {maximum: Settings.orders.length_30}
  validates :reciver_address, presence: true,
    length: {maximum: Settings.orders.length_50}
  validates :reciver_phone, presence: true,
    format: {with: Settings.orders.regex}
end
