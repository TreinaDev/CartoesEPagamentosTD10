require 'rails_helper'

describe 'Administrador tenta ver os tipos de cartões' do
  it 'com sucesso' do
    admin = FactoryBot.create(:admin)
    FactoryBot.create(:card_type, name: 'Black', start_points: 1500, emission: true, icon: 'https://raw.githubusercontent.com/GA9BR1/card_type_images/main/black.svg')
    FactoryBot.create(:card_type, name: 'Platinum', start_points: 800, emission: false, icon: 'https://raw.githubusercontent.com/GA9BR1/card_type_images/main/platinum.svg')

    login_as admin
    visit root_path
    within '#cards' do
      click_on 'Tipos de cartões'
    end

    within 'div#emission-enabled-card-types' do
      expect(page).to have_content('Black')
      expect(page).to have_css("img[src*='black.svg']")
    end
    within 'div#emission-disabled-card-types' do
      expect(page).to have_content('Platinum')
      expect(page).to have_css("img[src*='platinum.svg']")
    end
  end

  it 'e não existe nenhum tipo cadastrado' do
    admin = FactoryBot.create(:admin)
    login_as admin
    visit root_path
    within '#cards' do
      click_on 'Tipos de cartões'
    end

    within 'div#emission-enabled-card-types' do
      expect(page).to have_content('Nenhum tipo de cartão com emissão habilitada')
    end
    within 'div#emission-disabled-card-types' do
      expect(page).to have_content('Nenhum tipo de cartão com emissão desabilitada')
    end
  end
end
