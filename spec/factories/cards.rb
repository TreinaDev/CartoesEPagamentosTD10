FactoryBot.define do
  factory :card do
    number { '102030405060' }
    cpf { '66268563670' }
    points { 350 }
    status { 1 }
    card_type { nil }
  end
end
