require 'rails_helper'

describe 'Admin visita tela de empresas' do
  it 'e vê todas as empresas' do
    companies = []
    companies << Company.new(id: 1, brand_name: 'Samsung', registration_number: '71.223.406/0001-81')
    companies << Company.new(id: 2, brand_name: 'LG Electronics', registration_number: '25.325.922/0001-08')

    allow(Company).to receive(:all).and_return(companies)

    visit root_path
    click_on 'Disponibilizar tipos de cartões'

    expect(page).to have_content 'Disponibilizar tipos de cartões'
    within('a#1.company-card') do
      expect(page).to have_content 'Samsung'
      expect(page).to have_content 'CNPJ: 71.223.406/0001-81'
    end
    within('a#2.company-card') do
      expect(page).to have_content 'LG Electronics'
      expect(page).to have_content 'CNPJ: 25.325.922/0001-08'
    end
  end

  it 'e não tem empresas disponíveis' do
    companies = []
    allow(Company).to receive(:all).and_return(companies)

    visit root_path
    click_on 'Disponibilizar tipos de cartões'

    expect(page).to have_content 'Disponibilizar tipos de cartões'
    expect(page).to have_content 'Não existem empresas disponíveis'
    expect(page).not_to have_css('.company-card')
  end
end
