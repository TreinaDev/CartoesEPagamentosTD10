FactoryBot.define do
  factory :company_card_type do
    status { 1 }
    cnpj { 'MyString' }
    card_type { nil }
    conversion_tax { '9.99' }
  end
end
