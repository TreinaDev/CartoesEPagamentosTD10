FactoryBot.define do
  factory :card do
    number { "MyString" }
    cpf { "MyString" }
    points { 1 }
    status { 1 }
    card_type { nil }
  end
end
