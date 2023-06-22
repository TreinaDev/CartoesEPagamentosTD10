FactoryBot.define do
  factory :error_message do
    code { '001' }
    description { 'Cartão informado não existe' }
  end
end
