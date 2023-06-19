require 'rails_helper'

describe 'Admin visita tela de uma empresa' do
  it 'com sucesso' do
    admin = FactoryBot.create(:admin)
    companies = []
    companies << Company.new(id: 1, brand_name: 'Samsung', registration_number: '71.223.406/0001-81')
    companies << Company.new(id: 2, brand_name: 'LG Electronics', registration_number: '25.325.922/0001-08')

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

  it 'e vê os tipos de cartão' do
    company = Company.new(id: 1, brand_name: 'Samsung', registration_number: '71.223.406/0001-81')
    FactoryBot.create(:card_type)
    card_type2 = FactoryBot.create(:card_type, name: 'Black', start_points: 1500, emission: true)
    card_type2.icon.attach(
      io: Rails.root.join('spec/support/images/black.svg').open,
      filename: 'black.svg',
      content_type: 'image/svg+xml'
    )

    allow(Company).to receive(:all).and_return(companies)
    allow(Company).to receive(:find).and_return(companies[0])

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
end
