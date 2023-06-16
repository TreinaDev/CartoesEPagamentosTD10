require 'rails_helper'

describe 'API para bloqueio definitivo de cartão' do
  context 'DELETE /api/v1/cards/:id/block' do
    it 'falha se não existir o cartão que será bloqueado' do
      delete '/api/v1/cards/1/block'

      expect(response.status).to eq 404
    end

    it 'retorna erro em caso de falha interna' do
      allow(Card).to receive(:find).and_raise(ActiveRecord::ActiveRecordError)
      card_type = FactoryBot.create(:card_type)
      company_card_type = CompanyCardType.create!(cnpj: '71.223.406/0001-81', card_type:, conversion_tax: '9.99')

      card = Card.create!(cpf: '12193448000158', company_card_type_id: 1)

      delete "/api/v1/cards/#{card.id}/block"

      expect(response.status).to eq 500
    end

    it 'retorna erro em caso de cartão já bloqueado' do
      card_type = FactoryBot.create(:card_type)
      company_card_type = CompanyCardType.create!(cnpj: '71.223.406/0001-81', card_type:, conversion_tax: '9.99')

      card = Card.create!(cpf: '12193448000158', company_card_type_id: 1, status: :blocked)

      delete "/api/v1/cards/#{card.id}/block"

      expect(response.status).to eq 412
      expect(response.body).to include 'Status bloqueado não permite alterações no cartão'
    end

    it 'com sucesso' do
      allow(SecureRandom).to receive(:random_number).and_return('12345678912345678912')
      card_type = FactoryBot.create(:card_type)
      company_card_type = CompanyCardType.create!(cnpj: '71.223.406/0001-81', card_type:, conversion_tax: '9.99')

      Card.create!(cpf: '12193448000158', company_card_type_id: 1)

      delete '/api/v1/cards/1/block'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['number']).to eq '12345678912345678912'
      expect(json_response['cpf']).to eq '12193448000158'
      expect(json_response['status']).to eq 'blocked'
      expect(json_response['points']).to eq 100
      expect(json_response['name']).to eq 'Premium'
    end
  end
end
