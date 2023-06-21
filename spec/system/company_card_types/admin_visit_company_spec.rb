require 'rails_helper'

describe 'Admin visita tela de uma empresa' do
  it 'com sucesso' do
    admin = FactoryBot.create(:admin)
    companies = []
    companies << Company.new(id: 1, brand_name: 'Samsung', registration_number: '71.223.406/0001-81', active: true)
    companies << Company.new(id: 2, brand_name: 'LG', registration_number: '25.325.922/0001-08', active: true)

    allow(Company).to receive(:all).and_return(companies)
    allow(Company).to receive(:find).and_return(companies[0])

    login_as admin
    visit root_path
    within '#cards' do
      click_on 'Disponibilizar tipos de cartões'
    end
    click_on 'Samsung'

    expect(current_path).to eq company_path(companies[0].id)
    expect(page).to have_content 'Samsung'
    expect(page).to have_content 'CNPJ: 71.223.406/0001-81'
  end

  it 'e redireciona para a página de empresas quando for inativa' do
    admin = FactoryBot.create(:admin)
    companies = []
    companies << Company.new(id: 1, brand_name: 'Samsung', registration_number: '71.223.406/0001-81', active: false)
    companies << Company.new(id: 2, brand_name: 'LG', registration_number: '25.325.922/0001-08', active: true)

    allow(Company).to receive(:all).and_return(companies)
    allow(Company).to receive(:find).and_return(companies[0])

    login_as admin
    visit company_path(1)

    expect(current_path).to eq companies_path
    expect(page).to have_content 'Empresa Inativa'
  end

  it 'e vê os tipos de cartão' do
    admin = FactoryBot.create(:admin)
    companies = []
    companies << Company.new(id: 1, brand_name: 'Samsung', registration_number: '71.223.406/0001-81', active: true)
    companies << Company.new(id: 2, brand_name: 'LG', registration_number: '25.325.922/0001-08', active: true)
    FactoryBot.create(:card_type, name: 'Gold', icon: 'https://raw.githubusercontent.com/GA9BR1/card_type_images/main/gold.svg')
    FactoryBot.create(:card_type, name: 'Premium', icon: 'https://raw.githubusercontent.com/GA9BR1/card_type_images/main/premium.svg')

    allow(Company).to receive(:all).and_return(companies)
    allow(Company).to receive(:find).and_return(companies[0])

    login_as admin
    visit root_path
    within '#cards' do
      click_on 'Disponibilizar tipos de cartões'
    end
    click_on 'Samsung'

    expect(page).to have_css "img[src*='gold']"
    expect(page).to have_content 'Gold'
    expect(page).to have_css "img[src*='premium']"
    expect(page).to have_content 'Premium'
    expect(page).to have_button 'Vincular a empresa'
  end
end
