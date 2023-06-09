FactoryBot.define do
  factory :admin do
    email { 'admin@punti.com' }
    name { 'João Almeida' }
    password { 'senha_secreta' }
    cpf { '86882381208' }
    password_confirmation { 'senha_secreta' }
  end
end
