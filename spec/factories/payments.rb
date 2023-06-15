FactoryBot.define do
  factory :payment do
    order_number { '123456' }
    total_value { 1 }
    descount_amount { 1 }
    final_value { 1 }
    status { 0 }
    cpf { '41145977006' }
    card_number { '12548789563254125874' }
    payment_date { Date.current }
  end
end
