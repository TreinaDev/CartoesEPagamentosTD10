require 'rails_helper'

describe 'API de recarga de cartões' do
  context 'PATCH /api/v1/cards/recharge' do
    it 'retorna mensagem de sucesso e atualiza valor do cartão' do
      company = FactoryBot.create(:company_card_type, conversion_tax: 10)
      allow(SecureRandom).to receive(:alphanumeric).and_return('1122334455')
      card = FactoryBot.create(:card, points: 100, company_card_type: company)
      request = { request: [{ cpf: card.cpf, value: 15 }] }
      patch '/api/v1/cards/recharge', params: request
      card.reload

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['message']).to eq 'Recarga efetuada com sucesso'
      expect(card.points).to eq 250
    end

    it 'retorna mensagem de sucesso e atualiza valor de mais de um cartão' do
      company = FactoryBot.create(:company_card_type, conversion_tax: 10)
      first_card = FactoryBot.create(:card, points: 100, company_card_type: company)
      second_card = Card.create!(cpf: '50226428087', points: 100, company_card_type: company)
      fake_request = { request: [{ cpf: first_card.cpf, value: 15 }, { cpf: second_card.cpf, value: 15 }] }
      patch '/api/v1/cards/recharge', params: fake_request
      first_card.reload
      second_card.reload

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response[0]['message']).to eq 'Recarga efetuada com sucesso'
      expect(json_response[1]['message']).to eq 'Recarga efetuada com sucesso'
      expect(first_card.points).to eq 250
      expect(second_card.points).to eq 250
    end

    it 'retorna mensagem de erro quando cartão é inválido' do
      company = FactoryBot.create(:company_card_type, conversion_tax: 10)
      card = FactoryBot.create(:card, company_card_type: company, status: 'inactive')
      request = { request: [{ cpf: card.cpf, value: 15 }] }

      patch '/api/v1/cards/recharge', params: request

      expect(response.status).to eq 400
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['errors']).to eq 'CPF inválido ou cartão inativo'
    end

    it 'retorna mensagem de status 400 quando requisição está vazia' do
      company = FactoryBot.create(:company_card_type, conversion_tax: 10)
      card = Card.create!(cpf: '50226428087', points: 100, company_card_type: company)
      request = { request: [{ cpf: '45928010087', value: 15 }] }
      card.reload

      patch '/api/v1/cards/recharge', params: request

      expect(response.status).to eq 400
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['errors']).to eq 'CPF inválido ou cartão inativo'
    end
  end
end
