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

    it 'falha caso o CPF já possua um cartão ativo' do
      card_type = FactoryBot.create(:card_type)
      company_card_type = CompanyCardType.create!(cnpj: '71.223.406/0001-81', card_type:, conversion_tax: '9.99')

      Card.create!(cpf: '67855872043', company_card_type_id: 1)

      card = { card: { cpf: '67855872043', company_card_type_id: 1 } }

      post '/api/v1/cards', params: card

      expect(response.status).to eq 412
      expect(response.body).to include 'CPF já possui um cartão ativo'
    end

    it 'com sucesso' do
      card_type = FactoryBot.create(:card_type)
      company_card_type = CompanyCardType.create!(cnpj: '71.223.406/0001-81', card_type:, conversion_tax: '9.99')

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
