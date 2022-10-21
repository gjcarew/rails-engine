FactoryBot.define do
  factory :invoice_item do
    quantity { Faker::Number.between(from: 5, to: 40) }
    unit_price { Faker::Number.decimal(r_digits: 2) }
  end
end
