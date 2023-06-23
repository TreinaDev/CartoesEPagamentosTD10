require 'rails_helper'

describe 'API de recarga de cartões' do
  context 'PATCH /api/v1/cards/recharge' do
    context 'a requisição vem com um único cartão' do
      context 'e os dados são válidos' do
        it 'retorna uma mensagem de sucesso e atualiza seus pontos' do
          company = FactoryBot.create(:company_card_type, conversion_tax: 10)
          card = FactoryBot.create(:card, points: 100, company_card_type: company)
          request = { request: [{ cpf: card.cpf, value: 15 }] }
          patch '/api/v1/cards/recharge', params: request
          card.reload
    
          expect(response.status).to eq 200
          expect(response.content_type).to include 'application/json'
          json_response = response.parsed_body
          expect(json_response['message']).to eq 'Recargas finalizadas com sucesso'
          expect(card.points).to eq 113
        end
  
        it 'gera um deposito e um extrato referente ao cartão' do
          company = FactoryBot.create(:company_card_type, conversion_tax: 10)
          card = FactoryBot.create(:card, points: 100, company_card_type: company)
          request = { request: [{ cpf: card.cpf, value: 15 }] }
          patch '/api/v1/cards/recharge', params: request

          card_deposit = Deposit.last
          card_extract = Extract.last

          expect(card_deposit.card).to eq card
          expect(card_deposit.amount).to eq 13
          expect(card_extract.card_number).to eq card.number
          expect(card_extract.value).to eq 13
        end
      end
    end
    
    context 'a requisição vem com vários cartões' do
      context 'e os dados de todos são válidos' do
        it 'retorna uma mensagem de sucesso e atualiza os pontos de cada cartão' do
          company = FactoryBot.create(:company_card_type, conversion_tax: 10)
          first_card = FactoryBot.create(:card, points: 100, company_card_type: company)
          second_card = Card.create!(cpf: '50226428087', points: 100, company_card_type: company)
          request = { request: [{ cpf: first_card.cpf, value: 25 }, { cpf: second_card.cpf, value: 15 }] }
          patch '/api/v1/cards/recharge', params: request
          first_card.reload
          second_card.reload
    
          expect(response.status).to eq 200
          expect(response.content_type).to include 'application/json'
          json_response = response.parsed_body
          expect(json_response['message']).to eq 'Recargas finalizadas com sucesso'
          expect(first_card.points).to eq 122
          expect(second_card.points).to eq 113
        end

        it 'gera um deposito e um extrato referente a cada cartão' do
          company = FactoryBot.create(:company_card_type, conversion_tax: 10)
          first_card = FactoryBot.create(:card, points: 100, company_card_type: company)
          second_card = Card.create!(cpf: '50226428087', points: 100, company_card_type: company)
          request = { request: [{ cpf: first_card.cpf, value: 25 }, { cpf: second_card.cpf, value: 15 }] }
          patch '/api/v1/cards/recharge', params: request

          first_card_deposit = Deposit.find(1)
          second_card_deposit = Deposit.find(2)
          first_card_extract = Extract.find(1)
          second_card_extract = Extract.find(2)
          
          expect(first_card_deposit.card).to eq first_card
          expect(first_card_deposit.amount).to eq 22
          expect(second_card_deposit.card).to eq second_card
          expect(second_card_deposit.amount).to eq 13

          expect(first_card_extract.card_number).to eq first_card.number
          expect(first_card_extract.value).to eq 22
          expect(second_card_extract.card_number).to eq second_card.number
          expect(second_card_extract.value).to eq 13
        end
      end

      context 'e os dados de um são válidos e o do outro são inválidos' do
        it 'retorna uma mensagem de falha' do
          company = FactoryBot.create(:company_card_type, conversion_tax: 10)
          first_card = FactoryBot.create(:card, points: 100, company_card_type: company)
          second_card = Card.create!(cpf: '50226428087', points: 100, company_card_type: company, status: 'inactive')
          request = { request: [{ cpf: first_card.cpf, value: 25 }, { cpf: second_card.cpf, value: 15 }] }
          patch '/api/v1/cards/recharge', params: request
          first_card.reload
          second_card.reload

          expect(response.status).to eq 400
          expect(response.content_type).to include 'application/json'
          json_response = response.parsed_body
          expect(json_response['errors']).to eq 'Falha ao realizar as recargas, verifique as informações enviadas'
          expect(first_card.points).to eq 100
          expect(second_card.points).to eq 100
        end

        it 'e não gera depositos e nem extratos para os cartões' do
          company = FactoryBot.create(:company_card_type, conversion_tax: 10)
          first_card = FactoryBot.create(:card, points: 100, company_card_type: company)
          second_card = Card.create!(cpf: '50226428087', points: 100, company_card_type: company, status: 'inactive')
          request = { request: [{ cpf: first_card.cpf, value: 25 }, { cpf: second_card.cpf, value: 15 }] }
          patch '/api/v1/cards/recharge', params: request
          first_card.reload
          second_card.reload

          expect(first_card.points).to eq 100
          expect(second_card.points).to eq 100
        end
      end
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
