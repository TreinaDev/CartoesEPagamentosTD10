card_type = CardType.create!(name: 'Gold', start_points: 100,
                             icon: 'https://raw.githubusercontent.com/GA9BR1/card_type_images/main/gold.svg',
                             emission: true)
card_type2 = CardType.create!(name: 'Platinum', start_points: 200,
                              icon: 'https://raw.githubusercontent.com/GA9BR1/card_type_images/main/platinum.svg',
                              emission: true)
other_card_type = CardType.create!(name: 'Black', start_points: 300,
                                   icon: 'https://raw.githubusercontent.com/GA9BR1/card_type_images/main/black.svg',
                                   emission: true)
CompanyCardType.create!(
  status: :active,
  cnpj: '02423374000145',
  card_type:,
  conversion_tax: 20.00
)
CompanyCardType.create!(
  status: :inactive,
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
  status: :pending,
  card_number: card.number,
  payment_date: Date.current
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

  cpf: '33134090082'
)

Admin.create!(
  name: 'Pedro Monteiro',
  email: 'pedro@punti.com',
  password: 'password123',
  password_confirmation: 'password123',
  cpf: '24071765020'
)

Admin.create!(
  name: 'Gustavo Alberto',
  email: 'gustavo@punti.com',
  password: 'password',
  password_confirmation: 'password',
  cpf: '41115338684'
)
