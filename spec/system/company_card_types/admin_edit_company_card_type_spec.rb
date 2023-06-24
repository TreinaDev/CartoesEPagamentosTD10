require 'rails_helper'

describe 'Administrador tenta editar um tipo de cartão vinculado a uma empresa' do
  it 'com sucesso' do
    admin = FactoryBot.create(:admin)
    cashback_rule = FactoryBot.create(
      :cashback_rule,
      minimum_amount_points: 100, cashback_percentage: 10, days_to_use: 5
    )
    FactoryBot.create(
      :cashback_rule,
      minimum_amount_points: 300, cashback_percentage: 15, days_to_use: 25
    )
    company = Company.new(id: 1, brand_name: 'Samsung', registration_number: '71.223.406/0001-81')
    FactoryBot.create(:company_card_type, conversion_tax: 10, cashback_rule:)

    allow(Company).to receive(:find).and_return(company)

    login_as admin
    visit root_path
    within '#cards' do
      click_on 'Disponibilizar tipos de cartões'
    end
    click_on 'Samsung'

    within '#card_type_1' do
      select 'Valor mínimo de 300 pontos - cashback de 15% válido por 25 dia(s)', from: 'Regra de cashback'
      fill_in 'Taxa de conversão', with: 20
      click_on 'Salvar regra e taxa'
    end

    expect(current_path).to eq company_path(company.id)
    expect(page).to have_content 'Taxa e regra salvas com sucesso.'
    within '#card_type_1' do
      expect(page).to have_css 'option[selected="selected"]',
                               text: 'Valor mínimo de 300 pontos - cashback de 15% válido por 25 dia(s)'
      expect(page).to have_field 'Taxa de conversão', with: '20.0'
      expect(page).to have_button 'Salvar regra e taxa'
    end
  end

  it 'e falha pois utilizou dados inválidos' do
    admin = FactoryBot.create(:admin)
    cashback_rule = FactoryBot.create(
      :cashback_rule,
      minimum_amount_points: 100, cashback_percentage: 10, days_to_use: 5
    )
    FactoryBot.create(
      :cashback_rule,
      minimum_amount_points: 300, cashback_percentage: 15, days_to_use: 25
    )
    company = Company.new(id: 1, brand_name: 'Samsung', registration_number: '71.223.406/0001-81')
    FactoryBot.create(:company_card_type, conversion_tax: 10, cashback_rule:)

    allow(Company).to receive(:find).and_return(company)

    login_as admin
    visit root_path
    within '#cards' do
      click_on 'Disponibilizar tipos de cartões'
    end
    click_on 'Samsung'

    within '#card_type_1' do
      select 'Valor mínimo de 300 pontos - cashback de 15% válido por 25 dia(s)', from: 'Regra de cashback'
      fill_in 'Taxa de conversão', with: -10
      click_on 'Salvar regra e taxa'
    end

    expect(current_path).to eq company_path(company.id)
    expect(page).to have_content 'Taxa de conversão deve ser maior que 0'
    within '#card_type_1' do
      expect(page).to have_css 'option[selected="selected"]',
                               text: 'Valor mínimo de 100 pontos - cashback de 10% válido por 5 dia(s)'
      expect(page).to have_field 'Taxa de conversão', with: '10.0'
      expect(page).to have_button 'Salvar regra e taxa'
    end
  end
end
