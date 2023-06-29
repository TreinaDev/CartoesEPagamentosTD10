require 'rails_helper'

describe 'Administrador tenta registar um novo tipo de cartão' do
  it 'com sucesso' do
    admin = FactoryBot.create(:admin)
    login_as admin
    visit root_path
    within '#cards' do
      click_on 'Novo tipo de cartão'
    end
    fill_in('Nome', with: 'Premium')
    attach_file('Ícone', Rails.root.join('spec/support/images/premium.svg'))
    fill_in('Pontos iniciais', with: '67')
    click_on 'Salvar'

    expect(page).to have_content('Novo tipo de cartão criado com sucesso')
    expect(page).to have_content('Cartão Premium')
    expect(page).to have_content('Pontos iniciais 67 Pontos')
    expect(page).to have_css("img[src*='premium.svg']")
  end

  it 'com falha, pois o tipo de cartão já existe' do
    admin = FactoryBot.create(:admin)
    FactoryBot.create(:card_type)

    login_as admin
    visit root_path
    within '#cards' do
      click_on 'Novo tipo de cartão'
    end
    fill_in('Nome', with: 'Premium')
    attach_file('Ícone', Rails.root.join('spec/support/images/premium.svg'))
    fill_in('Pontos iniciais', with: '50')
    click_on 'Salvar'

    expect(page).to have_content('Não foi possível criar um novo tipo de cartão')
    expect(page).to have_content('Nome já está em uso')
  end
end
