require 'rails_helper'

describe 'Usuário tenta mudar status do cartão' do
  it 'e habilita com sucesso' do
    FactoryBot.create(:card_type, emission: false, name: 'Platinum')

    visit root_path
    click_on 'Tipos de cartão'
    click_on 'Platinum'
    click_on 'Habilitar emissão'

    expect(page).to have_button 'Desabilitar emissão'
    expect(page).not_to have_button 'Hablitar emissão'

  end

  it 'e desabilita com sucesso' do

    FactoryBot.create(:card_type, emission: true, name: 'Platinum')

    visit root_path
    click_on 'Tipos de cartão'
    click_on 'Platinum'
    click_on 'Desabilitar emissão'

    expect(page).to have_button 'Habilitar emissão'
    expect(page).not_to have_button 'Desabilitar emissão'

  end
end