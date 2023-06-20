require 'rails_helper'

describe 'Administrador vincula um tipo de cartão a uma empresa' do
  it 'com sucesso' do
    admin = FactoryBot.create(:admin)
    FactoryBot.create(:card_type, name: 'Premium', icon: 'https://raw.githubusercontent.com/GA9BR1/card_type_images/main/premium.svg')
    gold_card = FactoryBot.create(:card_type, name: 'Gold', icon: 'https://raw.githubusercontent.com/GA9BR1/card_type_images/main/gold.svg')
    company = Company.new(id: 1, brand_name: 'Samsung', registration_number: '71.223.406/0001-81')

    allow(Company).to receive(:find).and_return(company)

    login_as admin
    visit root_path
    within '#cards' do
      click_on 'Disponibilizar tipos de cartões'
    end
    click_on 'Samsung'
    find_button('Vincular a empresa', id: dom_id(gold_card)).click

    expect(current_path).to eq company_path(company.id)
    expect(page).to have_content 'Cartão vinculado a empresa com sucesso.'
    expect(page).to have_button 'Desativar disponibilidade', id: dom_id(gold_card)
    expect(page).not_to have_button 'Ativar disponibilidade', id: dom_id(gold_card)
  end
end
