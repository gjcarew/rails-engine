FactoryBot.define do
  factory :item do
    name { Faker::Food.dish }
    description { Faker::Food.description }
    unit_price { Faker::Number.within(range: 1.0..500.0) }
    merchant { Faker::Number.between(from: 1, to: 100) }
  end
end
