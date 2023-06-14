FactoryBot.define do
  factory :extract do
    date { '26/06/2023' }
    operation_type { 'Débito' }
    value { 1 }
    description { '13062023' }
    card_number { '12345678912345678912' }
  end
end
