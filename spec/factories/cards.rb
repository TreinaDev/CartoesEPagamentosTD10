FactoryBot.define do
  factory :card do
    number { '12345678912345678912' }
    cpf { '12193448000158' }
    points { 20 }
    status { 0 }
    association :company_card_type
  end
end
