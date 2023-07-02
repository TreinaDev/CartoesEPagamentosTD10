FactoryBot.define do
  factory :cashback_rule do
    minimum_amount_points { 500 }
    cashback_percentage { 9.99 }
    days_to_use { 10 }
  end
end
