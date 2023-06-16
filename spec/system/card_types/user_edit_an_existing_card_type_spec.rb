require 'rails_helper'

describe 'Usuário tenta editar um tipo de cartão' do
  it 'com sucesso' do
    card = FactoryBot.create(:card_type, name: 'Cartão Premium')
    visit root_path

    click_on 'Tipos de cartão'
    click_on 'Cartão Premium'
    click_on 'Editar'
    fill_in 'Nome', with: 'Cartão Platinum'
    click_on 'Salvar'
    expect(current_path).to eq(card_type_path(card))
    expect(page).to have_content('Cartão Platinum')
  end

  it 'e falha pois todos os campos não foram preenchidos' do
    FactoryBot.create(:card_type, name: 'Cartão Premium')
    visit root_path

    click_on 'Tipos de cartão'
    click_on 'Cartão Premium'
    click_on 'Editar'
    fill_in 'Nome', with: 'Cartão Platinum'
    fill_in 'Pontos iniciais', with: ''
    click_on 'Salvar'
    expect(page).to have_content('Não foi possível salvar as alterações')
  end
end
