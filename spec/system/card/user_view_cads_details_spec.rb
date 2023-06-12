require 'rails_helper'

describe 'Usuário vê detalhes do cartão' do
  it 'e precisa estar logado' do
    card_type = FactoryBot.create(:card_type)
    card = FactoryBot.create(:card, card_type:)
    admin = FactoryBot.create(:admin)

    login_as(admin)
    visit root_path
    click_on 'Cartões'
    click_on 'Ver Datalhes'

    expect(current_path).to eq card_path(card.id)
    expect(page).to have_content "Número do cartão: #{card.number}"
    expect(page).to have_content "CPF: #{card.cpf}"
    expect(page).to have_content "Pontos: #{card.points}"
    expect(page).to have_content "Status: #{card.status}"
    expect(page).to have_content "Tipo de cartão: #{card.card_type.name}"
  end

  it 'não tem acesso' do
    visit root_path
    click_on 'Cartões'

    expect(current_path).to eq new_admin_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end
end
