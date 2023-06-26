FactoryBot.define do
  factory :errors_association do
    association :payment
    association :error_message
  end
end
