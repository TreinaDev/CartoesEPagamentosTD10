require 'rails_helper'

describe 'API de consulta de cartão' do
  context 'GET /api/v1/card/card_number' do
    it 'e retorna dados do cartão com sucesso' do
      card = FactoryBot.create(:card)

      get "/api/v1/cards/#{card.cpf}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['cpf']).to eq '66268563670'
      expect(json_response['number']).to eq card.number
    end
    it 'e não encontra nenhum resultado' do
      get '/api/v1/cards/72477982036'

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
    end
  end
end
