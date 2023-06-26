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
      card_type = FactoryBot.create(:card_type, name: 'Black', start_points: 210)
      card_type.icon.attach(
        io: Rails.root.join('spec/support/images/black.svg').open,
        filename: 'black.svg',
        content_type: 'image/svg+xml'
      )
      other_card_type = FactoryBot.create(:card_type)
      cashback = FactoryBot.create(:cashback_rule, minimum_amount_points: 10, days_to_use: 10, cashback_percentage: 20)
      company_card_type = FactoryBot.create(
        :company_card_type,
        status: :active,
        cnpj: '02423374000145',
        card_type:,
        conversion_tax: 20.00,
        cashback_rule: cashback
      )
      FactoryBot.create(
        :company_card_type,
        status: :inactive,
        cnpj: '12423374000146',
        card_type: other_card_type,
        conversion_tax: 10.00,
        cashback_rule: cashback
      )

      key = ActionController::HttpAuthentication::Token.encode_credentials(Rails.application.credentials.api_key)
      get "/api/v1/company_card_types?cnpj=#{company_card_type.cnpj}", headers: { 'Api-Key' => key }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response.length).to eq 1
      expect(json_response[0]['name']).to eq 'Black'
      expect(json_response[0]['icon']).to eq url_for(card_type.icon)
      expect(json_response[0]['company_card_type_id']).to eq 1
      expect(json_response[0]['start_points']).to eq 210
      expect(json_response[0]['conversion_tax']).to eq 20.00
    end

    it 'apenas os tipos daquela empresa' do
      card_type = FactoryBot.create(:card_type, name: 'Black', start_points: 210)
      card_type.icon.attach(
        io: Rails.root.join('spec/support/images/black.svg').open,
        filename: 'black.svg',
        content_type: 'image/svg+xml'
      )
      cashback = FactoryBot.create(:cashback_rule, minimum_amount_points: 10, days_to_use: 10, cashback_percentage: 20)
      company_card_type = FactoryBot.create(
        :company_card_type,
        status: :active,
        cnpj: '02423374000145',
        card_type:,
        conversion_tax: 20.00,
        cashback_rule: cashback
      )
      FactoryBot.create(
        :company_card_type,
        status: :active,
        cnpj: '12423374000146',
        card_type:,
        conversion_tax: 15.00,
        cashback_rule: cashback
      )

      key = ActionController::HttpAuthentication::Token.encode_credentials(Rails.application.credentials.api_key)
      get "/api/v1/company_card_types?cnpj=#{company_card_type.cnpj}", headers: { 'Api-Key' => key }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response.length).to eq 1
      expect(json_response[0]['name']).to eq 'Black'
      expect(json_response[0]['icon']).to eq url_for(card_type.icon)
      expect(json_response[0]['company_card_type_id']).to eq 1
      expect(json_response[0]['start_points']).to eq 210
      expect(json_response[0]['conversion_tax']).to eq 20.00
    end

    it 'com sucesso' do
      card_type = FactoryBot.create(:card_type, name: 'Black', start_points: 210)
      black_img = Rails.root.join('spec/support/images/black.svg')
      card_type.icon.attach(
        io: black_img.open,
        filename: 'black.svg',
        content_type: 'image/svg+xml'
      )
      card_type2 = FactoryBot.create(:card_type, name: 'Gold', start_points: 150)
      gold_img = Rails.root.join('spec/support/images/gold.svg')
      card_type.icon.attach(
        io: gold_img.open,
        filename: 'gold.svg',
        content_type: 'image/svg+xml'
      )
      cashback = FactoryBot.create(:cashback_rule, minimum_amount_points: 10, days_to_use: 10, cashback_percentage: 20)
      company_card_type = FactoryBot.create(
        :company_card_type,
        status: :active,
        cnpj: '02423374000145',
        card_type:,
        conversion_tax: 20.00,
        cashback_rule: cashback
      )
      FactoryBot.create(
        :company_card_type,
        status: :active,
        cnpj: '02423374000145',
        card_type: card_type2,
        conversion_tax: 12.00,
        cashback_rule: cashback
      )
      key = ActionController::HttpAuthentication::Token.encode_credentials(Rails.application.credentials.api_key)
      get "/api/v1/company_card_types?cnpj=#{company_card_type.cnpj}", headers: { 'Api-Key' => key }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response.length).to eq 2
      expect(json_response[0]['name']).to eq 'Black'
      expect(json_response[0]['icon']).to eq url_for(card_type.icon)
      expect(json_response[0]['company_card_type_id']).to eq 1
      expect(json_response[0]['start_points']).to eq 210
      expect(json_response[0]['conversion_tax']).to eq 20.00
      expect(json_response[1]['name']).to eq 'Gold'
      expect(json_response[1]['icon']).to eq url_for(card_type2.icon)
      expect(json_response[1]['company_card_type_id']).to eq 2
      expect(json_response[1]['start_points']).to eq 150
      expect(json_response[1]['conversion_tax']).to eq 12.00
    end

    it 'e falha pois a chave de api está errada' do
      card_type = FactoryBot.create(:card_type, name: 'Black', start_points: 210)
      black_img = Rails.root.join('spec/support/images/black.svg')
      card_type.icon.attach(
        io: black_img.open,
        filename: 'black.svg',
        content_type: 'image/svg+xml'
      )
      card_type2 = FactoryBot.create(:card_type, name: 'Gold', start_points: 150)
      gold_img = Rails.root.join('spec/support/images/gold.svg')
      card_type.icon.attach(
        io: gold_img.open,
        filename: 'gold.svg',
        content_type: 'image/svg+xml'
      )
      company_card_type = FactoryBot.create(
        :company_card_type,
        status: :active,
        cnpj: '02423374000145',
        card_type:,
        conversion_tax: 20.00
      )
      FactoryBot.create(
        :company_card_type,
        status: :active,
        cnpj: '02423374000145',
        card_type: card_type2,
        conversion_tax: 12.00
      )
      key = ActionController::HttpAuthentication::Token.encode_credentials('e525d5eb-aa2c-4093-8fcd-9a35dafc85d9')
      get "/api/v1/company_card_types?cnpj=#{company_card_type.cnpj}", headers: { 'Api-Key' => key }

      expect(response.status).to eq 401
      expect(response.content_type).to include 'application/json'
      expect(response.body).to include 'Chave de API inválida'
    end
  end
end
