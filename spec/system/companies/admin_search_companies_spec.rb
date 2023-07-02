require 'rails_helper'

describe 'Administrador busca por uma empresa' do
  it 'a partir do página de empresas' do
    admin = FactoryBot.create(:admin)
    companies = []
    companies << Company.new(id: 1, brand_name: 'Samsung', registration_number: '71.223.406/0001-81', active: true)
    companies << Company.new(id: 2, brand_name: 'LG', registration_number: '25.325.922/0001-08', active: true)

    allow(Company).to receive(:all).and_return(companies)

    login_as admin
    visit root_path
    within '#cards' do
      click_on 'Disponibilizar tipos de cartões'
    end

    expect(page).to have_css 'input.search-field'
    expect(page).to have_css 'button.search-btn'
  end

  it 'e encontra uma empresa pelo nome' do
    admin = FactoryBot.create(:admin)

    json_data = Rails.root.join('spec/support/json/companies.json').read
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).and_return(fake_response)

    login_as admin
    visit root_path
    within '#cards' do
      click_on 'Disponibilizar tipos de cartões'
    end
    input = find('input.search-field')
    input.set('Samsung')
    find('button.search-btn').click

    expect(page).to have_content 'Busca'
    expect(page).to have_content 'Samsung'
    expect(page).not_to have_content 'LG'
  end

  it 'e encontra uma empresa pelo CNPJ' do
    admin = FactoryBot.create(:admin)

    json_data = Rails.root.join('spec/support/json/companies.json').read
    fake_response = double('faraday_response', status: 200, body: json_data)
    allow(Faraday).to receive(:get).and_return(fake_response)

    login_as admin
    visit root_path
    within '#cards' do
      click_on 'Disponibilizar tipos de cartões'
    end
    input = find('input.search-field')
    input.set('71223406000181')
    find('button.search-btn').click

    expect(page).to have_content 'Busca'
    expect(page).to have_content 'Samsung'
    expect(page).not_to have_content 'LG'
  end

  it 'e encontra múltiplas empresas' do
    admin = FactoryBot.create(:admin)
    companies = []
    companies << Company.new(id: 1, brand_name: 'Samsung', registration_number: '71.223.406/0001-81', active: true)
    companies << Company.new(id: 2, brand_name: 'LG', registration_number: '25.325.922/0001-08', active: true)

    allow(Company).to receive(:all).and_return(companies)

    login_as admin
    visit root_path
    within '#cards' do
      click_on 'Disponibilizar tipos de cartões'
    end
    input = find('input.search-field')
    input.set('0001')
    find('button.search-btn').click

    expect(page).to have_content 'Busca'
    expect(page).to have_content 'Samsung'
    expect(page).to have_content 'LG'
  end
end
