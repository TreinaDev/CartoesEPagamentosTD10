FactoryBot.define do
  factory :company_card_type do
    status { :active }
    cnpj { '71.223.406/0001-81' }
    association :card_type
    association :cashback_rule
    conversion_tax { '9.99' }
  end
end
