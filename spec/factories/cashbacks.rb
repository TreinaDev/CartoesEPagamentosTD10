FactoryBot.define do
  factory :cashback do
    amount { 1 }
    used { false }
    card { nil }
    cashback_rule { nil }
    payment { nil }
  end
end
