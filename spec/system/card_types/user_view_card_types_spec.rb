require 'rails_helper'

describe 'Usuário tenta ver os tipos de cartão' do
  it 'com sucesso' do
    FactoryBot.create(:card_type, name: 'Black', start_points: 1500, emission: true, icon: 'https://raw.githubusercontent.com/GA9BR1/card_type_images/main/black.svg')
    FactoryBot.create(:card_type, name: 'Platinum', start_points: 800, emission: false, icon: 'https://raw.githubusercontent.com/GA9BR1/card_type_images/main/platinum.svg')

    visit root_path
    click_on 'Tipos de cartão'

    within 'div#emission-enabled-card-types' do
      expect(page).to have_content('Black')
      expect(page).to have_css("img[src*='black.svg']")
    end
    within 'div#emission-disabled-card-types' do
      expect(page).to have_content('Platinum')
      expect(page).to have_css("img[src*='platinum.svg']")
    end
  end
end
