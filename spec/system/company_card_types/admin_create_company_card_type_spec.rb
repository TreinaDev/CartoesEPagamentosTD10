require 'rails_helper'

describe 'Administrador vincula um tipo de cartão a uma empresa' do
  it 'com sucesso' do
    admin = FactoryBot.create(:admin)
    FactoryBot.create(:cashback_rule, minimum_amount_points: 300, cashback_percentage: 10, days_to_use: 5)
    FactoryBot.create(:card_type, name: 'Premium', icon: 'https://raw.githubusercontent.com/GA9BR1/card_type_images/main/premium.svg')
    FactoryBot.create(:card_type, name: 'Gold', icon: 'https://raw.githubusercontent.com/GA9BR1/card_type_images/main/gold.svg')
    company = Company.new(id: 1, brand_name: 'Samsung', registration_number: '71.223.406/0001-81')

    allow(Company).to receive(:find).and_return(company)

    login_as admin
    visit root_path
    within '#cards' do
      click_on 'Disponibilizar tipos de cartões'
    end
    click_on 'Samsung'
    within '#card_type_2' do
      select 'Valor mínimo de 300 pontos - cashback de 10% válido por 5 dia(s)', from: 'Regra de cashback'
      fill_in 'Taxa de conversão', with: 10
      click_on 'Vincular a empresa'
    end

    expect(current_path).to eq company_path(company.id)
    expect(page).to have_content 'Cartão vinculado a empresa com sucesso.'
    expect(page).to have_button 'Desativar disponibilidade'
    expect(page).not_to have_button 'Ativar disponibilidade'
  end

  it 'e falha pois utilizou dados inválidos' do
    admin = FactoryBot.create(:admin)
    FactoryBot.create(:cashback_rule, minimum_amount_points: 300, cashback_percentage: 10, days_to_use: 5)
    FactoryBot.create(:card_type, name: 'Premium', icon: 'https://raw.githubusercontent.com/GA9BR1/card_type_images/main/premium.svg')
    FactoryBot.create(:card_type, name: 'Gold', icon: 'https://raw.githubusercontent.com/GA9BR1/card_type_images/main/gold.svg')
    company = Company.new(id: 1, brand_name: 'Samsung', registration_number: '71.223.406/0001-81')

    allow(Company).to receive(:find).and_return(company)

    login_as admin
    visit root_path
    within '#cards' do
      click_on 'Disponibilizar tipos de cartões'
    end
    click_on 'Samsung'
    within '#card_type_2' do
      select 'Valor mínimo de 300 pontos - cashback de 10% válido por 5 dia(s)', from: 'Regra de cashback'
      fill_in 'Taxa de conversão', with: ''
      click_on 'Vincular a empresa'
    end

    expect(current_path).to eq company_path(company.id)
    expect(page).to have_content 'Taxa de conversão não pode ficar em branco.Taxa de conversão não é um número'
    expect(page).not_to have_button 'Desativar disponibilidade'
    expect(page).not_to have_button 'Ativar disponibilidade'
  end
end
