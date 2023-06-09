require 'rails_helper'

describe 'Administrador disponibiliza tipo de cartão para uma empresa' do
  include ActionView::RecordIdentifier

  it 'com sucesso' do
    FactoryBot.create(:card_type, name: 'Premium', icon: 'https://raw.githubusercontent.com/GA9BR1/card_type_images/main/premium.svg')
    card_1 = FactoryBot.create(:card_type, name: 'Gold', icon: 'https://raw.githubusercontent.com/GA9BR1/card_type_images/main/gold.svg')
    company = Company.new(id: 1, brand_name: 'Samsung', registration_number: '71.223.406/0001-81')

    visit company_path(company.id)
    find_button('Disponibilizar', id: dom_id(card_1)).click

    expect(page).to have_css "card_type_#{card_1.id}", text: 'Indisponibilizar'
    expect(page).not_to have_css "card_type_#{card_1.id}", text: 'Disponibilizar'
    # expect(page).to have_button('Indisponibilizar', id: dom_id(card_1))
    # expect(page).not_to have_button('Disponibilizar', id: dom_id(card_1))
  end
end