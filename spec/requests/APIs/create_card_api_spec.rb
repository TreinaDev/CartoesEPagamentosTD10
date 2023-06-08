require 'rails_helper'

describe 'API para emissão de cartão' do
  context 'POST /api/v1/cards' do
    it 'falha se parametros não estão completos' do
      card = { card: { cpf: '', company_card_type_id: '' } }

      post '/api/v1/cards', params: card

      expect(response.status).to eq 412
      expect(response.body).to include 'CPF não pode ficar em branco'
      expect(response.body).to include 'Tipo de cartão da empresa é obrigatório(a)'
    end

    it 'retorna erro em caso de falha interna' do
      allow(Card).to receive(:new).and_raise(ActiveRecord::ActiveRecordError)

      card = { card: { cpf: '12193448000158', company_card_type_id: 1 } }

      post '/api/v1/cards', params: card

      expect(response.status).to eq 500
    end

    it 'com sucesso' do
      FactoryBot.create(:company_card_type)

      card = { card: { cpf: '12193448000158', company_card_type_id: 1 } }

      allow(SecureRandom).to receive(:random_number).and_return('12345678912345678912')

      post '/api/v1/cards', params: card

      expect(response.status).to eq 201
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['number']).to eq '12345678912345678912'
      expect(json_response['cpf']).to eq '12193448000158'
      expect(json_response['status']).to eq 'active'
      expect(json_response['points']).to eq 100
      expect(json_response['name']).to eq 'Premium'
    end
  end
end
