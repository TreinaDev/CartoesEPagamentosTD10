FactoryBot.define do
  factory :card_type do
    name { 'Premium' }
    icon { 'https://i.imgur.com/YmQ9jRN.png' }
    start_points { 100 }
    emission { true }
  end
end
