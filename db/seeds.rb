ErrorMessage.create!(
  code: '001',
  description: 'Cartão informado não existe'
)

ErrorMessage.create!(
  code: '002',
  description: 'Cartão não está ativo'
)

ErrorMessage.create!(
  code: '003',
  description: 'Cartão não pertence ao CPF informado'
)

ErrorMessage.create!(
  code: '004',
  description: 'Valor da compra maior que o saldo do cartão'
)

ErrorMessage.create!(
  code: '005',
  description: 'Administrador não aprovou a compra'
)

card_type = CardType.new(name: 'Gold', start_points: 100, emission: true)
card_type.icon.attach(
  io: Rails.root.join('spec/support/images/gold.svg').open,
  filename: 'gold.svg',
  content_type: 'image/svg+xml'
)
card_type.save

card_type2 = CardType.new(name: 'Platinum', start_points: 200, emission: true)
card_type2.icon.attach(
  io: Rails.root.join('spec/support/images/premium.svg').open,
  filename: 'premium.svg',
  content_type: 'image/svg+xml'
)
card_type2.save

other_card_type = CardType.new(name: 'Black', start_points: 300, emission: false)
other_card_type.icon.attach(
  io: Rails.root.join('spec/support/images/black.svg').open,
  filename: 'black.svg',
  content_type: 'image/svg+xml'
)
other_card_type.save

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
  card_type: card_type,
  conversion_tax: 15.00
)

CompanyCardType.create!(
  status: :active,
  cnpj: '02423374000145',
  card_type: card_type2,
  conversion_tax: 12.00
)

card = Card.create!(cpf: '30383993024', company_card_type_id: 1)

card2 = Card.create!(cpf: '40247099090', company_card_type_id: 3)

card3 = Card.create!(cpf: '52399436059', company_card_type_id: 3)

card4 = Card.create!(cpf: '62222694000', company_card_type_id: 4, status: 'inactive')

payment = Payment.create!(
  order_number: '12345678912',
  total_value: 60,
  descount_amount: 10,
  final_value: 50,
  cpf: card.cpf,
  card_number: card.number,
  payment_date: Date.current
)

Payment.create!(
  order_number: '35241568212',
  total_value: 50,
  descount_amount: 0,
  final_value: 50,
  cpf: card.cpf,
  card_number: card.number,
  payment_date: Date.current
)

Payment.create!(
  order_number: '56812547891',
  total_value: 10,
  descount_amount: 0,
  final_value: 10,
  cpf: card.cpf,
  card_number: '512456521645221',
  payment_date: Date.current
)

Payment.create!(
  order_number: '87512456988',
  total_value: 10,
  descount_amount: 0,
  final_value: 10,
  cpf: card4.cpf,
  card_number: card4.number,
  payment_date: Date.current
)

Payment.create!(
  order_number: '92548741589',
  total_value: 1000,
  descount_amount: 0,
  final_value: 1000,
  cpf: card2.cpf,
  card_number: card2.number,
  payment_date: Date.current
)

Payment.create!(
  order_number: '41589925487',
  total_value: 1000,
  descount_amount: 0,
  final_value: 1000,
  cpf: card2.cpf,
  card_number: card4.number,
  payment_date: Date.current
)

deposit = Deposit.create!(
  card: card3,
  amount: 20,
  description: 'Recarga feita pela empresa', 
  deposit_code: '216846513'
)

Extract.create!(
  date: deposit.created_at, operation_type: 'recarga', value: deposit.amount,
  description: "Recarga #{deposit.deposit_code}", card_number: card.number
)

Admin.create!(
  name: 'Admin Punti',
  email: 'admin@punti.com',
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
