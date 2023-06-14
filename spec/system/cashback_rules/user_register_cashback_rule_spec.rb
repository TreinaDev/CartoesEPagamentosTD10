require 'rails_helper'

describe 'Administrador tenta registar uma nova regra de cashback' do
  it 'com sucesso' do
    admin = Admin.create!(
      name: 'John Doe', email: 'john@punti.com', cpf: '05129456084',
      password: '123456', password_confirmation: '123456', 
    )

    login_as admin
    visit root_path
    click_on 'Criar regra de cashback'
    fill_in 'Valor mínimo', with: 300
    fill_in 'Porcentagem de retorno', with: 10
    fill_in 'Deve ser válido por quantos dias?', with: 10
    click_on 'Criar regra'

    expect(current_path).to eq cashback_rules_path
    expect(page).to have_content 'Valor mínimo 300 Pontos'
    expect(page).to have_content 'Porcentagem de retorno 10%'
    expect(page).to have_content 'Válido por 10 dias'
  end

  it 'com falha, pois tentou criar uma regra que já existe' do
    admin = Admin.create!(
      name: 'John Doe', email: 'john@punti.com', cpf: '05129456084',
      password: '123456', password_confirmation: '123456', 
    )
    CashbackRule.create!(minimum_amount_points: 300, cashback_percentage: 10, days_to_use: 10)

    login_as admin
    visit root_path
    click_on 'Criar regra de cashback'
    fill_in 'Valor mínimo', with: 300
    fill_in 'Porcentagem de retorno', with: 10
    fill_in 'Deve ser válido por quantos dias?', with: 10
    click_on 'Criar regra'

    expect(page).to have_content 'Regra já existente.'
  end

  it 'com falha, pois tentou criar com um ou mais dados inválidos' do
    admin = Admin.create!(
      name: 'John Doe', email: 'john@punti.com', cpf: '05129456084',
      password: '123456', password_confirmation: '123456', 
    )
    CashbackRule.create!(minimum_amount_points: 300, cashback_percentage: 10, days_to_use: 10)

    login_as admin
    visit root_path
    click_on 'Criar regra de cashback'
    fill_in 'Valor mínimo', with: -300
    fill_in 'Porcentagem de retorno', with: -10
    fill_in 'Deve ser válido por quantos dias?', with: -10
    click_on 'Criar regra'

    expect(page).to have_content 'O valor mínimo em pontos deve ser um inteiro positivo.'
    expect(page).to have_content 'A porcentagem de retorno deve ser um inteiro positivo.'
    expect(page).to have_content 'A quantidade de dias deve ser um inteiro positivo.'
  end
end