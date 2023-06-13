require 'rails_helper'

describe 'Administrador muda status de um tipo de cartão vinculado a uma empresa' do
  it 'de ativado para desativado' do
    gold_card = FactoryBot.create(:card_type, name: 'Gold', icon: 'https://raw.githubusercontent.com/GA9BR1/card_type_images/main/gold.svg')
    premium_card = FactoryBot.create(:card_type, name: 'Premium', icon: 'https://raw.githubusercontent.com/GA9BR1/card_type_images/main/premium.svg')
    company = Company.new(id: 1, brand_name: 'Samsung', registration_number: '71.223.406/0001-81')
    FactoryBot.create(:company_card_type, card_type: premium_card, status: :active)
    FactoryBot.create(:company_card_type, card_type: gold_card, status: :active)

    allow(Company).to receive(:find).and_return(company)

    visit company_path(company.id)
    find_button('Desativar disponibilidade', id: dom_id(premium_card)).click

    expect(page).to have_content 'Cartão desabilitado para a empresa com sucesso.'
    expect(page).to have_button 'Ativar disponibilidade', id: dom_id(premium_card)
    expect(page).not_to have_button 'Desativar disponibilidade', id: dom_id(premium_card)
    expect(page).not_to have_button 'Ativar disponibilidade', id: dom_id(gold_card)
  end

  it 'de desativado para ativado' do
    gold_card = FactoryBot.create(:card_type, name: 'Gold', icon: 'https://raw.githubusercontent.com/GA9BR1/card_type_images/main/gold.svg')
    premium_card = FactoryBot.create(:card_type, name: 'Premium', icon: 'https://raw.githubusercontent.com/GA9BR1/card_type_images/main/premium.svg')
    company = Company.new(id: 1, brand_name: 'Samsung', registration_number: '71.223.406/0001-81')
    FactoryBot.create(:company_card_type, card_type: premium_card, status: :inactive)
    FactoryBot.create(:company_card_type, card_type: gold_card, status: :inactive)

    allow(Company).to receive(:find).and_return(company)

    visit company_path(company.id)
    find_button('Ativar disponibilidade', id: dom_id(premium_card)).click

    expect(page).to have_content 'Cartão habilitado para a empresa com sucesso.'
    expect(page).to have_button 'Desativar disponibilidade', id: dom_id(premium_card)
    expect(page).not_to have_button 'Ativar disponibilidade', id: dom_id(premium_card)
    expect(page).not_to have_button 'Desativar disponibilidade', id: dom_id(gold_card)
  end
end
