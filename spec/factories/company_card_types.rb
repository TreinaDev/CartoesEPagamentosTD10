FactoryBot.define do
  factory :company_card_type do
    status { :available }
    cnpj { '71.223.406/0001-81' }
    card_type
    conversion_tax { '9.99' }
  end
end
