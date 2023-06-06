FactoryBot.define do
  factory :payment do
    order_number { "MyString" }
    code { "MyString" }
    total_value { 1 }
    descount_amount { 1 }
    final_value { 1 }
    status { 1 }
    cpf { "MyString" }
    card_number { "MyString" }
  end
end
