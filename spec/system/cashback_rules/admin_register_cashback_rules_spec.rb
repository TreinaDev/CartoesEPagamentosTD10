require 'rails_helper'

describe 'Administrador tenta registar uma nova regra de cashback' do
  it 'com sucesso' do
    admin = FactoryBot.create(:admin)

    login_as admin
    visit root_path
    within '#cashback' do
      click_on 'Nova regra de cashback'
    end
    fill_in 'Valor mínimo', with: 300
    fill_in 'Porcentagem de retorno', with: 10
    fill_in 'Quantidade de dias', with: 10
    click_on 'Criar regra'

    expect(current_path).to eq cashback_rules_path
    expect(page).to have_content 'Valor mínimo 300 Pontos'
    expect(page).to have_content 'Porcentagem de retorno 10%'
    expect(page).to have_content 'Válido por 10 Dias'
  end

  it 'com falha, pois tentou criar uma regra que já existe' do
    admin = FactoryBot.create(:admin)
    FactoryBot.create(:cashback_rule)

    login_as admin
    visit root_path
    within '#cashback' do
      click_on 'Nova regra de cashback'
    end
    fill_in 'Valor mínimo', with: 500
    fill_in 'Porcentagem de retorno', with: 9.99
    fill_in 'Quantidade de dias', with: 10
    click_on 'Criar regra'

    expect(page).to have_content 'A regra de cashback já existe'
    expect(CashbackRule.count).to eq 1
  end

  it 'com falha, pois tentou criar com um ou mais dados inválidos' do
    admin = FactoryBot.create(:admin)

    login_as admin
    visit root_path
    within '#cashback' do
      click_on 'Nova regra de cashback'
    end
    fill_in 'Valor mínimo', with: -300
    fill_in 'Porcentagem de retorno', with: -10
    fill_in 'Quantidade de dias', with: -10
    click_on 'Criar regra'

    expect(page).to have_content 'deve ser maior que 0'
    expect(CashbackRule.count).to eq 0
  end

  it 'com falha, pois tentou criar com campos em branco' do
    admin = FactoryBot.create(:admin)

    login_as admin
    visit root_path
    within '#cashback' do
      click_on 'Nova regra de cashback'
    end
    fill_in 'Valor mínimo', with: ''
    fill_in 'Porcentagem de retorno', with: ''
    fill_in 'Quantidade de dias', with: ''
    click_on 'Criar regra'

    expect(page).to have_content 'não é um número'
    expect(CashbackRule.count).to eq 0
  end
end
