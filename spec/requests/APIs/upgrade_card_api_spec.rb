require 'rails_helper'

describe 'API para upgrade de cartão' do
  context 'POST /api/v1/cards' do
    it 'falha se parametros não estão completos' do
      FactoryBot.create(:card, cpf: '34447873087')
      card = { card: { cpf: '34447873087', company_card_type_id: '' } }

      post '/api/v1/cards/upgrade', params: card

      expect(response.status).to eq 412
      expect(response.body).to include 'Tipo de cartão da empresa é obrigatório(a)'
    end

    it 'retorna erro em caso de falha interna' do
      FactoryBot.create(:card, cpf: '34447873087')
      allow(Card).to receive(:new).and_raise(ActiveRecord::ActiveRecordError)

      card = { card: { cpf: '34447873087', company_card_type_id: 1 } }

      post '/api/v1/cards/upgrade', params: card

      expect(response.status).to eq 500
    end

    it 'falha se CPF não possui cartão válido anterior' do
      FactoryBot.create(:company_card_type)
      card = { card: { cpf: '34447873087', company_card_type_id: 1 } }

      post '/api/v1/cards/upgrade', params: card

      expect(response.status).to eq 404
    end

    it 'não altera o status do cartão anterior em caso de falha' do
      card_type1 = FactoryBot.create(:card_type)
      card_type2 = FactoryBot.create(:card_type, name: 'Black', icon: 'icone', start_points: 120)

      CompanyCardType.create!(
        cnpj: '12193448000158',
        card_type: card_type1,
        conversion_tax: 10,
        status: :active
      )
      CompanyCardType.create!(
        cnpj: '15581683000195',
        card_type: card_type2,
        conversion_tax: 12,
        status: :inactive
      )

      Card.create!(cpf: '34447873087', company_card_type_id: 1)
      card = { card: { cpf: '34447873087', company_card_type_id: 2 } }

      post '/api/v1/cards/upgrade', params: card

      expect(response.status).to eq 412
      old_card = Card.find(1)
      expect(old_card.status).to eq 'active'
    end

    it 'falha se tiver o mesmo tipo de cartão que o anterior' do
      company_card_type = FactoryBot.create(:company_card_type)

      Card.create!(cpf: '34447873087', company_card_type:)
      card = { card: { cpf: '34447873087', company_card_type_id: 1 } }

      post '/api/v1/cards/upgrade', params: card

      expect(response.status).to eq 412
      expect(response.body).to include 'Mesmo tipo de cartão'
    end

    it 'com sucesso' do
      card_type1 = FactoryBot.create(:card_type)
      card_type2 = FactoryBot.create(:card_type, name: 'Black', icon: 'icone', start_points: 120)

      company_card_type1 = CompanyCardType.create!(
        cnpj: '12193448000158',
        card_type: card_type1,
        conversion_tax: 10,
        status: :active
      )
      CompanyCardType.create!(
        cnpj: '15581683000195',
        card_type: card_type2,
        conversion_tax: 12,
        status: :active
      )

      Card.create!(cpf: '34447873087', company_card_type: company_card_type1)
      card = { card: { cpf: '34447873087', company_card_type_id: 2 } }
      allow(SecureRandom).to receive(:random_number).and_return('12345678912345678912')

      post '/api/v1/cards/upgrade', params: card

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['number']).to eq '12345678912345678912'
      expect(json_response['cpf']).to eq '34447873087'
      expect(json_response['status']).to eq 'active'
      expect(json_response['points']).to eq 120
      expect(json_response['name']).to eq 'Black'
    end
  end
end
