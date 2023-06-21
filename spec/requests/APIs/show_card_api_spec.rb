require 'rails_helper'

describe 'API de consulta de cartão' do
  context 'GET /api/v1/card/card_number' do
    it 'e retorna dados do cartão com sucesso' do
      card = FactoryBot.create(:card)

      key = ActionController::HttpAuthentication::Token.encode_credentials(Rails.application.credentials.api_key)
      get "/api/v1/cards/#{card.cpf}", headers: { 'Api-Key' => key }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['id']).to eq card.id
      expect(json_response['cpf']).to eq card.cpf
      expect(json_response['number']).to eq card.number
      expect(json_response['points']).to eq card.points
      expect(json_response['status']).to eq card.status
      expect(json_response['name']).to eq card.company_card_type.card_type.name
      expect(json_response['conversion_tax']).to eq card.company_card_type.conversion_tax.to_s
    end

    it 'e não encontra nenhum resultado' do
      key = ActionController::HttpAuthentication::Token.encode_credentials(Rails.application.credentials.api_key)
      get '/api/v1/cards/72477982036', headers: { 'Api-Key' => key }

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
    end

    it 'e falha pois a chave de api está errada' do
      card = FactoryBot.create(:card)

      key = ActionController::HttpAuthentication::Token.encode_credentials('324143gfdaf-f34ggs-gsgf')
      get "/api/v1/cards/#{card.cpf}", headers: { 'Api-Key' => key }

      expect(response.status).to eq 401
      expect(response.content_type).to include 'application/json'
      expect(response.body).to include 'Chave de API inválida'
    end
  end
end
