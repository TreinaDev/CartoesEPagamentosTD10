require 'rails_helper'

describe 'API do tipo de cartão' do
  context 'GET /api/v1/company_card_types/02423374000145' do 
    it 'success' do
      card_type = CardType.create!(name: 'Black', icon: 'icone', start_points: 210)
      company_card_type = CompanyCardType.create!(status: :active, cnpj: '02423374000145', 
                                                  card_type: card_type, conversion_tax: 20.00)

      get "/api/v1/company_card_types/#{company_card_type.cnpj}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 1
      expect(json_response[0]['name']).to eq 'Black'
      expect(json_response[0]['icon']).to eq 'icone'
      expect(json_response[0]['id']).to eq 1
      expect(json_response[0]['start_points']).to eq 210
      expect(json_response[0]['conversion_tax']).to eq 20.00
    end
  end
end