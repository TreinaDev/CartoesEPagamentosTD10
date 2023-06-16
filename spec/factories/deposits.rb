FactoryBot.define do
  factory :deposit do
    amount { 1 }
    description { 'Recarga' }
    deposit_code { '216846513' }
    association :card
  end
end
