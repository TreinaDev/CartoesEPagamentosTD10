require 'rails_helper'

describe 'Administrador tenta editar um tipo de cartão' do
  it 'com sucesso' do
    admin = FactoryBot.create(:admin)
    card = FactoryBot.create(:card_type, name: 'Cartão Premium')

    login_as admin
    visit root_path

    within '#cards' do
      click_on 'Tipos de cartões'
    end
    click_on 'Cartão Premium'
    click_on 'Editar'
    fill_in 'Nome', with: 'Cartão Platinum'
    click_on 'Salvar'

    expect(current_path).to eq(card_type_path(card))
    expect(page).to have_content('Cartão Platinum')
  end

  it 'e falha pois todos os campos não foram preenchidos' do
    admin = FactoryBot.create(:admin)
    FactoryBot.create(:card_type, name: 'Cartão Premium')

    login_as admin
    visit root_path

    within '#cards' do
      click_on 'Tipos de cartões'
    end
    click_on 'Cartão Premium'
    click_on 'Editar'
    fill_in 'Nome', with: 'Cartão Platinum'
    fill_in 'Ícone', with: ''
    fill_in 'Pontos iniciais', with: ''
    click_on 'Salvar'

    expect(page).to have_content('Não foi possível salvar as alterações')
  end
end
