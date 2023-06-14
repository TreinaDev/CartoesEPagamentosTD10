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

      get "/api/v1/extracts?card_number=#{card.number}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response[0]['value']).to eq payment.final_value
      expect(json_response[0]['description']).to eq "Pedido #{payment.order_number}"
      expect(json_response[1]['value']).to eq deposit.amount
      expect(json_response[1]['description']).to eq deposit.description
    end
    it 'e retorna erro 404 quando não encontra nenhum registro' do
      get '/api/v1/extracts?card_number=123456789'

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
    end
  end
end
