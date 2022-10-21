FactoryBot.define do
  factory :invoice do
    status { [*0..2].sample }
  end
end
