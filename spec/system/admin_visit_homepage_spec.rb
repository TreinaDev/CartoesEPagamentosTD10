require 'rails_helper'

describe 'Administrador visita a página inicial' do
  it 'e vê tela inicial' do
    admin = FactoryBot.create(:admin)
    login_as admin
    visit root_path

    expect(page).to have_content 'Boas vindas'
  end
end
