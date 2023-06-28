require 'rails_helper'

describe 'Quando ocorre um erro na aplicação' do
  it 'retorna a página do erro 404' do
    admin = FactoryBot.create(:admin)

    login_as admin
    visit root_path
    visit card_type_path(99)

    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
end
