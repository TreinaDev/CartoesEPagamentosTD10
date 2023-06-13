require 'rails_helper'

describe 'GET /api/v1/card' do
  it 'com sucesso' do
    card = FactoryBot.create(:card)

    get "/api/v1/cards/#{card.cpf}"

    expect(response.status).to eq 200
    expect(response.content_type).to include 'application/json'
    json_response = JSON.parse(response.body)
    expect(json_response['cpf']).to eq '66268563670'
    expect(json_response['number']).to eq '12345678912345678912'
  end
end