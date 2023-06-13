require 'rails_helper'

describe 'GET /api/v1/card' do
  it 'com sucesso a partir do cpf do funcionário' do
    card = FactoryBot.create(:card)

    get "/api/v1/cards/#{card.cpf}"

    expect(response.status).to eq 200
    expect(response.content_type).to include 'application/json'
    json_response = response.parsed_body
    expect(json_response['cpf']).to eq '66268563670'
    expect(json_response['number']).to eq card.number
  end
  it 'com falha de cpf não encontrado' do
    get '/api/v1/cards/72477982036'

    expect(response.status).to eq 404
    expect(response.content_type).to include 'application/json'
  end
end
