# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
card_type = CardType.create!(name: 'Black', icon: 'icone', start_points: 210)
other_card_type = CardType.create!(name: 'Premium', icon: 'icone3', start_points: 170)
card_type2 = CardType.create!(name: 'Starter', icon: 'icone2', start_points: 150)
CompanyCardType.create!(
  status: :active,
  cnpj: '02423374000145',
  card_type:,
  conversion_tax: 20.00
)
CompanyCardType.create!(
  status: :pending,
  cnpj: '02423374000145',
  card_type: other_card_type,
  conversion_tax: 10.00
)
CompanyCardType.create!(
  status: :active,
  cnpj: '12423374000146',
  card_type:,
  conversion_tax: 15.00
)
CompanyCardType.create!(
  status: :active,
  cnpj: '02423374000145',
  card_type: card_type2,
  conversion_tax: 12.00
)
card = Card.create!(cpf: '30383993024', company_card_type_id: 1)

payment = Payment.create!(
  order_number: '12345678912',
  code: '456789',
  total_value: 20,
  descount_amount: 10,
  final_value: 46,
  cpf: card.cpf,
  status: 1,
  card_number: card.number
)
Extract.create!(
  date: payment.created_at, operation_type: 'débito', value: payment.final_value,
  description: "Pedido #{payment.order_number}", card_number: payment.card_number
)
deposit = Deposit.create!(
  card:,
  amount: 20,
  description: 'Recarga',
  deposit_code: '216846513'
)
Extract.create!(
  date: deposit.created_at, operation_type: 'depósito', value: deposit.amount,
  description: deposit.description, card_number: deposit.card.number
)
Admin.create!(
  name: 'Luiz da Silva',
  email: 'luizs@punti.com',
  password: '123456',
  password_confirmation: '123456',
  cpf: '60756961050'
)

Admin.create!(
  name: 'Luana Guarnier',
  email: 'luana@punti.com',
  password: '123456',
  password_confirmation: '123456',
  cpf: '41115338684'
)
