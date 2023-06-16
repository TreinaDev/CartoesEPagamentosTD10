require 'rails_helper'

describe 'Administrador tenta mudar status do cartão' do
  it 'e habilita com sucesso' do
    admin = FactoryBot.create(:admin)
    FactoryBot.create(:card_type, emission: false, name: 'Platinum')

    login_as admin
    visit root_path
    within '#cards' do
      click_on 'Tipos de cartões'
    end
    click_on 'Platinum'
    click_on 'Habilitar emissão'

    expect(page).to have_button 'Desabilitar emissão'
    expect(page).not_to have_button 'Hablitar emissão'
  end

  it 'e desabilita com sucesso' do
    admin = FactoryBot.create(:admin)
    FactoryBot.create(:card_type, emission: true, name: 'Platinum')

    login_as admin
    visit root_path
    within '#cards' do
      click_on 'Tipos de cartões'
    end
    click_on 'Platinum'
    click_on 'Desabilitar emissão'

    expect(page).to have_button 'Habilitar emissão'
    expect(page).not_to have_button 'Desabilitar emissão'
  end
end
