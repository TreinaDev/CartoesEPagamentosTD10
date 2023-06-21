require 'rails_helper'

describe 'API de consulta do extrato de um cartão' do
  context 'GET /api/v1/extracts?card_number=card_number' do
    it 'e retorna lista de itens do extrato com sucesso' do
      card = FactoryBot.create(:card)
      payment = FactoryBot.create(:payment, card_number: card.number)
      FactoryBot.create(:extract, date: payment.created_at, operation_type: 'débito', value: payment.final_value,
                                  description: "Pedido #{payment.order_number}", card_number: payment.card_number)
      deposit = FactoryBot.create(:deposit, card:)
      FactoryBot.create(:extract, date: deposit.created_at, operation_type: 'depósito', value: deposit.amount,
                                  description: deposit.description, card_number: deposit.card.number)

      key = ActionController::HttpAuthentication::Token.encode_credentials(Rails.application.credentials.api_key)
      get "/api/v1/extracts?card_number=#{card.number}", headers: { 'Api-Key' => key }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response[0]['value']).to eq payment.final_value
      expect(json_response[0]['description']).to eq "Pedido #{payment.order_number}"
      expect(json_response[1]['value']).to eq deposit.amount
      expect(json_response[1]['description']).to eq deposit.description
    end

    it 'e retorna erro 404 quando não encontra nenhum registro do cartão' do
      key = ActionController::HttpAuthentication::Token.encode_credentials(Rails.application.credentials.api_key)
      get '/api/v1/extracts?card_number=123456789', headers: { 'Api-Key' => key }

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
    end

    it 'e retorna mensagem informando que não existem transações realizadas' do
      card = FactoryBot.create(:card)

      key = ActionController::HttpAuthentication::Token.encode_credentials(Rails.application.credentials.api_key)
      get "/api/v1/extracts?card_number=#{card.number}", headers: { 'Api-Key' => key }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['message']).to eq('Nenhuma transação registrada')
    end

    it 'e falha pois a chave de api está errada' do
      card = FactoryBot.create(:card)
      payment = FactoryBot.create(:payment, card_number: card.number)
      FactoryBot.create(:extract, date: payment.created_at, operation_type: 'débito', value: payment.final_value,
                                  description: "Pedido #{payment.order_number}", card_number: payment.card_number)
      deposit = FactoryBot.create(:deposit, card:)
      FactoryBot.create(:extract, date: deposit.created_at, operation_type: 'depósito', value: deposit.amount,
                                  description: deposit.description, card_number: deposit.card.number)

      key = ActionController::HttpAuthentication::Token.encode_credentials('324143gfdaf-f34ggs-gsgf')
      get "/api/v1/extracts?card_number=#{card.number}", headers: { 'Api-Key' => key }

      expect(response.status).to eq 401
      expect(response.content_type).to include 'application/json'
      expect(response.body).to include 'Chave de API inválida'
    end
  end
end
