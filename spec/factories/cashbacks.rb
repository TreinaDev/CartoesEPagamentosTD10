FactoryBot.define do
  factory :cashback do
    amount { 10 }
    used { false }
    card { 1 }
    cashback_rule { 1 }
    association :payment
  end
end
