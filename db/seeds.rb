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
Card.create!(cpf: '12193448000158', company_card_type_id: 1)
Admin.create!(
  name: 'Luiz da Silva',
  email: 'luizs@punti.com',
  password: '123456',
  password_confirmation: '123456',
  cpf: '05129456084'
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
  cpf: '98946290080'
)
