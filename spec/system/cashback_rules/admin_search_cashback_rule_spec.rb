require 'rails_helper'

describe 'Administrador busca por uma regra de cashback' do
  it 'a partir da página de regras de cashback' do
    admin = FactoryBot.create(:admin)

    login_as admin
    visit root_path
    within '#cashback' do
      click_on 'Regras de cashback'
    end

    expect(page).to have_css 'input.search-field'
    expect(page).to have_css 'button.search-btn'
  end

  it 'e encontra uma regra de cashback pelo valor mínimo' do
    admin = FactoryBot.create(:admin)
    FactoryBot.create(:cashback_rule, minimum_amount_points: 300, cashback_percentage: 15,
                                      days_to_use: 6)
    FactoryBot.create(:cashback_rule, minimum_amount_points: 100, cashback_percentage: 5,
                                      days_to_use: 20)

    login_as admin
    visit root_path
    within '#cashback' do
      click_on 'Regras de cashback'
    end
    input = find('input.search-field')
    input.set('300')
    find('button.search-btn').click

    expect(page).to have_content 'Busca'
    expect(page).to have_content 'Valor mínimo 300 Pontos'
    expect(page).not_to have_content 'Valor mínimo 100 Pontos'
  end

  it 'e encontra uma regra de cashback pela porcentagem de cashback' do
    admin = FactoryBot.create(:admin)
    FactoryBot.create(:cashback_rule, minimum_amount_points: 300, cashback_percentage: 15,
                                      days_to_use: 6)
    FactoryBot.create(:cashback_rule, minimum_amount_points: 100, cashback_percentage: 5,
                                      days_to_use: 20)

    login_as admin
    visit root_path
    within '#cashback' do
      click_on 'Regras de cashback'
    end
    input = find('input.search-field')
    input.set('15')
    find('button.search-btn').click

    expect(page).to have_content 'Busca'
    expect(page).to have_content 'Porcentagem de retorno 15%'
    expect(page).not_to have_content 'Porcentagem de retorno 5%'
  end

  it 'e encontra uma regra de cashback pelo número de dias válidos' do
    admin = FactoryBot.create(:admin)
    FactoryBot.create(:cashback_rule, minimum_amount_points: 300, cashback_percentage: 15,
                                      days_to_use: 6)
    FactoryBot.create(:cashback_rule, minimum_amount_points: 100, cashback_percentage: 5,
                                      days_to_use: 20)

    login_as admin
    visit root_path
    within '#cashback' do
      click_on 'Regras de cashback'
    end
    input = find('input.search-field')
    input.set('6')
    find('button.search-btn').click

    expect(page).to have_content 'Busca'
    expect(page).to have_content 'Válido por 6 Dias'
    expect(page).not_to have_content 'Válido por 20 Dias'
  end

  it 'e encontra múltiplas regras de cashback' do
    admin = FactoryBot.create(:admin)
    FactoryBot.create(:cashback_rule, minimum_amount_points: 300, cashback_percentage: 15,
                                      days_to_use: 6)
    FactoryBot.create(:cashback_rule, minimum_amount_points: 100, cashback_percentage: 5,
                                      days_to_use: 3)
    FactoryBot.create(:cashback_rule, minimum_amount_points: 50, cashback_percentage: 3,
                                      days_to_use: 20)
    FactoryBot.create(:cashback_rule, minimum_amount_points: 999, cashback_percentage: 9,
                                      days_to_use: 9)

    login_as admin
    visit root_path
    within '#cashback' do
      click_on 'Regras de cashback'
    end
    input = find('input.search-field')
    input.set('3')
    find('button.search-btn').click

    expect(page).to have_content 'Busca'
    expect(page).to have_content 'Valor mínimo 300 Pontos'
    expect(page).to have_content 'Porcentagem de retorno 15%'
    expect(page).to have_content 'Válido por 6 Dias'
    expect(page).to have_content 'Valor mínimo 100 Pontos'
    expect(page).to have_content 'Porcentagem de retorno 5%'
    expect(page).to have_content 'Válido por 3 Dias'
    expect(page).to have_content 'Valor mínimo 50 Pontos'
    expect(page).to have_content 'Porcentagem de retorno 3%'
    expect(page).to have_content 'Válido por 20 Dias'
    expect(page).not_to have_content 'Valor mínimo 999 Pontos'
    expect(page).not_to have_content 'Porcentagem de retorno 9%'
    expect(page).not_to have_content 'Válido por 9 Dias'
  end
end
