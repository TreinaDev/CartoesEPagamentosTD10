FactoryBot.define do
  factory :payment do
    order_number { '56654564231' }
    code { '54646' }
    total_value { 10 }
    descount_amount { 15 }
    final_value { 56 }
    status { 1 }
    cpf { '66268563670' }
    card_number { '12345678912345678912' }
  end
end
