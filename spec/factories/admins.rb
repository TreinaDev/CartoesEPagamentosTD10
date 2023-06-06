FactoryBot.define do
  factory :admin do
    email { 'admin@punti.com' }
    name { 'João Almeida' }
    password { 'senha_secreta' }
  end
end
