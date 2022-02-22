FactoryBot.define do
  factory :subscription do
    title { Faker::Beer.name }
    price { Faker::Number.within(range: 1..100) }
    frequency { Faker::Number.within(range: 1..100) }
    status { Subscription.statuses.values.sample }
    association :customer_id, factory: :customer
  end
end
