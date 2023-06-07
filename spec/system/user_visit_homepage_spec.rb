require 'rails_helper'

describe 'Visitante navega pela app' do
  it 'e vê tela inicial' do
    visit root_path
  end
end
