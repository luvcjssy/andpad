FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    description { Faker::Lorem.paragraph }
    price { Faker::Number.decimal(l_digits: 2) }
    author { create(:author) }
  end
end
