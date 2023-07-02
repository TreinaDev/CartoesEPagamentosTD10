FactoryBot.define do
  factory :card do
    number { '31088319132162400813' }
    cpf { '66268563670' }
    points { 1500 }
    status { 0 }
    association :company_card_type
  end
end
