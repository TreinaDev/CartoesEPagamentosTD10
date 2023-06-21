require 'rails_helper'

describe 'API de consulta de cartão' do
  context 'GET /api/v1/card/card_number' do
    it 'e retorna dados do cartão com sucesso' do
      card = FactoryBot.create(:card)

      card_type = FactoryBot.create(:card_type, name: 'Black',
                                                icon: 'cartaoblack')

      company = FactoryBot.create(:company_card_type, status: :active,
                                                      cnpj: '71.223.406/0001-81',
                                                      card_type:,
                                                      conversion_tax: '9.99')

      FactoryBot.create(:card, cpf: '91795928050',
                               company_card_type_id: company.id)

      get "/api/v1/cards/#{card.cpf}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response.is_a?(Array)).to eq(false)
      expect(json_response['id']).to eq card.id
      expect(json_response['cpf']).to eq card.cpf
      expect(json_response['number']).to eq card.number
      expect(json_response['points']).to eq card.points
      expect(json_response['status']).to eq card.status
      expect(json_response['name']).to eq card.company_card_type.card_type.name
      expect(json_response['conversion_tax']).to eq card.company_card_type.conversion_tax.to_s
    end

    it 'e não encontra nenhum resultado' do
      get '/api/v1/cards/72477982036'

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
    end
  end
end
