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

other_card_type = CardType.new(name: 'Black', start_points: 300, emission: true)
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
  card_type:,
  conversion_tax: 15.00
)
CompanyCardType.create!(
  status: :active,
  cnpj: '02423374000145',
  card_type: card_type2,
  conversion_tax: 12.00
)
Card.create!(cpf: '12193448000158', company_card_type_id: 1)
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
