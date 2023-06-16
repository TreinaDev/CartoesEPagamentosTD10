require 'rails_helper'

describe 'Usuário tenta ver os tipos de cartão' do
  it 'com sucesso' do
    black_img = Rails.root.join('spec', 'support', 'images', 'black.svg')
    premium_img = Rails.root.join('spec', 'support', 'images', 'premium.svg')
    card_type = FactoryBot.build(:card_type, name: 'Black', start_points: 1500, emission: true)
    card_type.icon.attach(
      io: black_img.open,
      filename: 'black.svg',
      content_type: 'image/svg+xml'
    )
    card_type.save

    card_type2 = FactoryBot.build(:card_type, name: 'Premium', start_points: 800, emission: false)
    card_type2.icon.attach(
      io: premium_img.open,
      filename: 'premium.svg',
      content_type: 'image/svg+xml'
    )
    card_type2.save

    visit root_path
    click_on 'Tipos de cartão'

    within 'div#emission-enabled-card-types' do
      expect(page).to have_content('Black')
      expect(page).to have_css("img[src*='black.svg']")
    end
    within 'div#emission-disabled-card-types' do
      expect(page).to have_content('Premium')
      expect(page).to have_css("img[src*='premium.svg']")
    end
  end

  it 'e não existe nenhum tipo cadastrado' do
    visit root_path
    click_on 'Tipos de cartão'

    expect(page).to have_content('TIME 3')
    within 'div#emission-enabled-card-types' do
      expect(page).to have_content('Nenhum tipo de cartão com emissão habilitada')
    end
    within 'div#emission-disabled-card-types' do
      expect(page).to have_content('Nenhum tipo de cartão com emissão desabilitada')
    end
  end
end
