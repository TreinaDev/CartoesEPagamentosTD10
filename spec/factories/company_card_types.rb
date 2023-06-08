FactoryBot.define do
  factory :company_card_type do
    status { 5 }
    cnpj { '12193448000158' }
    association :card_type
    conversion_tax { '9.99' }
  end
end
