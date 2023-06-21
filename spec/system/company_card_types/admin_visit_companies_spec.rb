require 'rails_helper'

describe 'Admin visita tela de empresas' do
  it 'e vê todas as empresas ativas' do
    admin = FactoryBot.create(:admin)
    companies = []
    companies << Company.new(id: 1, brand_name: 'Samsung', registration_number: '71.223.406/0001-81', active: true)
    companies << Company.new(id: 2, brand_name: 'LG', registration_number: '25.325.922/0001-08', active: true)
    companies << Company.new(id: 3, brand_name: 'Apple', registration_number: '25.325.922/0001-07', active: false)

    allow(Company).to receive(:all).and_return(companies)

    login_as admin
    visit root_path
    within '#cards' do
      click_on 'Disponibilizar tipos de cartões'
    end

    expect(page).to have_content 'Disponibilizar tipos de cartões'
    within('a#1.company-card') do
      expect(page).to have_content 'Samsung'
      expect(page).to have_content 'CNPJ: 71.223.406/0001-81'
    end
    within('a#2.company-card') do
      expect(page).to have_content 'LG'
      expect(page).to have_content 'CNPJ: 25.325.922/0001-08'
    end
    expect(page).not_to have_content 'Apple'
    expect(page).not_to have_content 'CNPJ: 25.325.922/0001-07'
  end

  it 'e não tem empresas disponíveis' do
    admin = FactoryBot.create(:admin)
    companies = []
    allow(Company).to receive(:all).and_return(companies)

    login_as admin
    visit root_path
    within '#cards' do
      click_on 'Disponibilizar tipos de cartões'
    end

    expect(page).to have_content 'Disponibilizar tipos de cartões'
    expect(page).to have_content 'Não existem empresas disponíveis'
    expect(page).not_to have_css('.company-card')
  end
end
