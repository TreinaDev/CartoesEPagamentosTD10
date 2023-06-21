require 'rails_helper'
require 'net/http'

describe 'API do tipo de cartão' do
  context 'GET /api/v1/company_card_types?cnpj=cnpj_number' do
    it 'retorna vazio se não tiver tipo de cartão disponível' do
      key = ActionController::HttpAuthentication::Token.encode_credentials(Rails.application.credentials.api_key)
      get '/api/v1/company_card_types?cnpj=000000000000000', headers: { 'Api-Key' => key }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response).to eq []
    end

    it 'retorna erro em caso de falha interna' do
      allow(CompanyCardType).to receive(:where).and_raise(ActiveRecord::ActiveRecordError)

      key = ActionController::HttpAuthentication::Token.encode_credentials(Rails.application.credentials.api_key)
      get '/api/v1/company_card_types?cnpj=56577242000105', headers: { 'Api-Key' => key }

      expect(response.status).to eq 500
    end

    it 'retorna erro caso não encontre um registro com o cnpj' do
      allow(CompanyCardType).to receive(:where).and_raise(ActiveRecord::RecordNotFound)

      key = ActionController::HttpAuthentication::Token.encode_credentials(Rails.application.credentials.api_key)
      get '/api/v1/company_card_types?cnpj=000000000000000', headers: { 'Api-Key' => key }

      expect(response.status).to eq 404
    end

    it 'com status disponível' do
      card_type = CardType.create!(name: 'Black', icon: 'icone', start_points: 210)
      other_card_type = CardType.create!(name: 'Premium', icon: 'icone1', start_points: 170)
      company_card_type = CompanyCardType.create!(
        status: :active,
        cnpj: '02423374000145',
        card_type:,
        conversion_tax: 20.00
      )
      CompanyCardType.create!(
        status: :inactive,
        cnpj: '02423374000145',
        card_type: other_card_type,
        conversion_tax: 10.00
      )

      key = ActionController::HttpAuthentication::Token.encode_credentials(Rails.application.credentials.api_key)
      get "/api/v1/company_card_types?cnpj=#{company_card_type.cnpj}", headers: { 'Api-Key' => key }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response.length).to eq 1
      expect(json_response[0]['name']).to eq 'Black'
      expect(json_response[0]['icon']).to eq 'icone'
      expect(json_response[0]['company_card_type_id']).to eq 1
      expect(json_response[0]['start_points']).to eq 210
      expect(json_response[0]['conversion_tax']).to eq 20.00
    end

    it 'apenas os tipos daquela empresa' do
      card_type = CardType.create!(name: 'Black', icon: 'icone', start_points: 210)
      company_card_type = CompanyCardType.create!(
        status: :active,
        cnpj: '02423374000145',
        card_type:,
        conversion_tax: 20.00
      )
      CompanyCardType.create!(
        status: :active,
        cnpj: '12423374000146',
        card_type:,
        conversion_tax: 15.00
      )

      key = ActionController::HttpAuthentication::Token.encode_credentials(Rails.application.credentials.api_key)
      get "/api/v1/company_card_types?cnpj=#{company_card_type.cnpj}", headers: { 'Api-Key' => key }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response.length).to eq 1
      expect(json_response[0]['name']).to eq 'Black'
      expect(json_response[0]['icon']).to eq 'icone'
      expect(json_response[0]['company_card_type_id']).to eq 1
      expect(json_response[0]['start_points']).to eq 210
      expect(json_response[0]['conversion_tax']).to eq 20.00
    end

    it 'com sucesso' do
      card_type = CardType.create!(name: 'Black', icon: 'icone', start_points: 210)
      card_type2 = CardType.create!(name: 'Starter', icon: 'icone2', start_points: 150)
      company_card_type = CompanyCardType.create!(
        status: :active,
        cnpj: '02423374000145',
        card_type:,
        conversion_tax: 20.00
      )
      CompanyCardType.create!(
        status: :active,
        cnpj: '02423374000145',
        card_type: card_type2,
        conversion_tax: 12.00
      )
      key = ActionController::HttpAuthentication::Token.encode_credentials(Rails.application.credentials.api_key)
      get "/api/v1/company_card_types?cnpj=#{company_card_type.cnpj}", headers: { 'Api-Key' => key }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response.length).to eq 2
      expect(json_response[0]['name']).to eq 'Black'
      expect(json_response[0]['icon']).to eq 'icone'
      expect(json_response[0]['company_card_type_id']).to eq 1
      expect(json_response[0]['start_points']).to eq 210
      expect(json_response[0]['conversion_tax']).to eq 20.00
      expect(json_response[1]['name']).to eq 'Starter'
      expect(json_response[1]['icon']).to eq 'icone2'
      expect(json_response[1]['company_card_type_id']).to eq 2
      expect(json_response[1]['start_points']).to eq 150
      expect(json_response[1]['conversion_tax']).to eq 12.00
    end

    it 'e falha pois a chave de api está errada' do
      card_type = CardType.create!(name: 'Black', icon: 'icone', start_points: 210)
      card_type2 = CardType.create!(name: 'Starter', icon: 'icone2', start_points: 150)
      company_card_type = CompanyCardType.create!(
        status: :active,
        cnpj: '02423374000145',
        card_type:,
        conversion_tax: 20.00
      )
      CompanyCardType.create!(
        status: :active,
        cnpj: '02423374000145',
        card_type: card_type2,
        conversion_tax: 12.00
      )
      key = ActionController::HttpAuthentication::Token.encode_credentials('324143gfdaf-f34ggs-gsgf')
      get "/api/v1/company_card_types?cnpj=#{company_card_type.cnpj}", headers: { 'Api-Key' => key }

      expect(response.status).to eq 401
      expect(response.content_type).to include 'application/json'
      expect(response.body).to include 'Chave de API inválida'
    end
  end
end
