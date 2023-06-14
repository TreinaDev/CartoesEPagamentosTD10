FactoryBot.define do
  factory :cashback_rule do
    minimum_amount_points { 1 }
    cashback_percentage { "9.99" }
    days_to_use { 1 }
  end
end
