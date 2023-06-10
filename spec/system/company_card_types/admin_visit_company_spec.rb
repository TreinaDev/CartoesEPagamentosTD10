require 'rails_helper'

describe 'Admin visita tela de uma empresa' do
  it 'com sucesso' do
    companies = []
    companies << Company.new(id: 1, brand_name: 'Samsung', registration_number: '71.223.406/0001-81')
    companies << Company.new(id: 2, brand_name: 'LG Electronics', registration_number: '25.325.922/0001-08')

    allow(Company).to receive(:all).and_return(companies)
    allow(Company).to receive(:find).and_return(companies[0])

    # login_as admin
    visit root_path
    click_on 'Disponibilizar tipos de cartões'
    click_on 'Samsung'

    expect(current_path).to eq company_path(companies[0].id)
    expect(page).to have_content 'Samsung'
    expect(page).to have_content 'CNPJ: 71.223.406/0001-81'
  end

  it 'e vê os tipos de cartão' do
    company = Company.new(id: 1, brand_name: 'Samsung', registration_number: '71.223.406/0001-81')
    FactoryBot.create(:card_type, name: 'Gold', icon: 'https://raw.githubusercontent.com/GA9BR1/card_type_images/main/gold.svg')
    FactoryBot.create(:card_type, name: 'Premium', icon: 'https://raw.githubusercontent.com/GA9BR1/card_type_images/main/premium.svg')

    allow(Company).to receive(:find).and_return(company)

    visit company_path(company.id)

    expect(page).to have_css "img[src*='gold']"
    expect(page).to have_content 'Gold'
    expect(page).to have_css "img[src*='premium']"
    expect(page).to have_content 'Premium'
    expect(page).to have_button 'Vincular a empresa'
  end
end
