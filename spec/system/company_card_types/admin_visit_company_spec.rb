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
    company = Company.new(id: 1, brand_name: 'Samsung', registration_number: '71.223.406/0001-81', active: true)
    FactoryBot.create(:card_type)
    card_type2 = FactoryBot.create(:card_type, name: 'Black', start_points: 1500, emission: true)
    card_type2.icon.attach(
      io: Rails.root.join('spec/support/images/black.svg').open,
      filename: 'black.svg',
      content_type: 'image/svg+xml'
    )

    allow(Company).to receive(:all).and_return([company])
    allow(Company).to receive(:find).and_return(company)

    login_as admin
    visit root_path
    within '#cards' do
      click_on 'Disponibilizar tipos de cartões'
    end
    click_on 'Samsung'

    expect(page).to have_css "img[src*='premium']"
    expect(page).to have_content 'Premium'
    expect(page).to have_css "img[src*='black']"
    expect(page).to have_content 'Black'
    expect(page).to have_button 'Vincular a empresa'
  end

  it 'e endpoint está fora do ar' do
    admin = FactoryBot.create(:admin)
    allow(Faraday).to receive(:get).with('http://localhost:3000/api/v1/companies/1').and_raise(CompanyConnectionError)

    login_as admin
    visit company_path(1)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Não foi possível buscar dados das empresas'
  end
end
