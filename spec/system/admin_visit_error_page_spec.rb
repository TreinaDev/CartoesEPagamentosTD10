require 'rails_helper'

describe 'Quando ocorre um erro na aplicação' do
  it 'retorna a página do erro 404' do
    allow_any_instance_of(HomeController).to receive(:index).and_raise(ActiveRecord::RecordNotFound)
    admin = FactoryBot.create(:admin)

    login_as admin
    visit root_path

    expect(page).to have_content("The page you were looking for doesn't exist.")
  end
  it 'retorna a página do erro 500' do
    allow_any_instance_of(HomeController).to receive(:index).and_raise(Faraday::ConnectionFailed)
    admin = FactoryBot.create(:admin)

    login_as admin
    visit root_path

    expect(page).to have_content("We're sorry, but something went wrong.")
  end
end
