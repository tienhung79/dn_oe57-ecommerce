# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


User.create!(name: "Example User",
  email: "example@gmail.com",
  password: "foobar",
  password_confirmation: "foobar",
  gender: true,
  date_of_birth: Date.new(2000, 5, 15),
  phone_number: "0123456789",
  address: "Da Nang",
  is_admin: true,
  activated: true,
  activated_at: Time.zone.now)

99.times do |n|
name = Faker::Name.name
email = "example-#{n+1}@gmail.com"
password = "password"
gender = Faker::Boolean.boolean
date_of_birth = Faker::Date.birthday(min_age: 18, max_age: 65)
phone_number = "0" + Faker::Number.number(digits: 9).to_s
address = Faker::Address.full_address
User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password,
    gender: gender,
    date_of_birth: date_of_birth,
    phone_number: phone_number,
    address: address
  )
end
