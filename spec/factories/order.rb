FactoryBot.define do
  factory :order do
    reciver_name {"Reciver name"}
    reciver_address {"Reciver address"}
    reciver_phone {"0123456789"}
    total_price {100000}
    status {1}
    user_id {nil}
  end
end
