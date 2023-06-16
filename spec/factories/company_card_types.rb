FactoryBot.define do
  factory :company_card_type do
    status { :active }
    cnpj { '71.223.406/0001-81' }
    conversion_tax { '9.99' }
    card_type
  end
end
