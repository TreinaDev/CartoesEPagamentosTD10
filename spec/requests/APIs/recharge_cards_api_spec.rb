require 'rails_helper'

describe 'API de recarga de cartões' do
  context 'PATCH /api/v1/cards/recharge' do
    context 'quando a requisição esta vazia' do
      it 'retorna mensagem de bad request (status 400)' do
        patch '/api/v1/cards/recharge'

        expect(response.status).to eq 400
        expect(response.content_type).to include 'application/json'
        json_response = response.parsed_body
        expect(json_response['errors']).to eq 'Erro nos parâmetros enviados'
      end
    end

    context 'ao recebe um cartão' do
      context 'e caso os dados sejam válidos:' do
        it 'atualiza os pontos, gera um deposito, gera um extrato e retorna mensagem de sucesso' do
          company = FactoryBot.create(:company_card_type, conversion_tax: 10)
          card = FactoryBot.create(:card, cpf: '66268563670', points: 100, company_card_type: company)
          request = { recharge: [{ cpf: card.cpf, value: 15 }] }
          patch '/api/v1/cards/recharge', params: request
          card.reload
          card_deposit = Deposit.find(1)
          card_extract = Extract.find(1)

          expect(response.status).to eq 200
          expect(response.content_type).to include 'application/json'
          json_response = response.parsed_body
          expect(json_response[0]['cpf']).to eq '66268563670'
          expect(json_response[0]['message']).to eq 'Recarga efetuada com sucesso'
          expect(card.points).to eq 117
          expect(card_deposit.card).to eq card
          expect(card_extract.card_number).to eq card.number
          expect(card_deposit.amount).to eq 17
          expect(card_extract.value).to eq 17
        end

        it 'retorne um erro caso a atualização não tenha sucesso' do
          company = FactoryBot.create(:company_card_type, conversion_tax: 10)
          card = FactoryBot.create(:card, cpf: '66268563670', points: 100, company_card_type: company)
          request = { recharge: [{ cpf: card.cpf, value: 15 }] }
          allow_any_instance_of(Card).to receive(:update).and_return(false)

          patch '/api/v1/cards/recharge', params: request

          expect(response.status).to eq 200
          expect(response.content_type).to include 'application/json'
          json_response = response.parsed_body
          expect(json_response[0]['cpf']).to eq '66268563670'
          expect(json_response[0]['errors']).to eq 'Não foi possível concluir a recarga. Erro interno'
        end
      end
      context 'e caso ele esteja inativo: ' do
        it 'não atualiza os pontos, não gera um deposito, não gera um extrato e retorna mensagem de falha' do
          company = FactoryBot.create(:company_card_type, conversion_tax: 10)
          card = FactoryBot.create(:card, cpf: '66268563670', points: 100, company_card_type: company,
                                          status: :inactive)
          request = { recharge: [{ cpf: card.cpf, value: 15 }] }
          patch '/api/v1/cards/recharge', params: request
          card.reload
          card_deposit = Deposit.find_by(card:)
          card_extract = Extract.find_by(card_number: card.number)

          expect(response.status).to eq 200
          expect(response.content_type).to include 'application/json'
          json_response = response.parsed_body
          expect(json_response[0]['cpf']).to eq '66268563670'
          expect(json_response[0]['errors']).to eq 'Cartão não encontrado ou inativo'
          expect(card.points).to eq 100
          expect(card_deposit).to be_falsy
          expect(card_extract).to be_falsy
        end
      end
    end

    context 'ao receber mais de um cartão' do
      context 'e recarregar todos' do
        it 'retorna uma mensagem de sucesso para cada' do
          company = FactoryBot.create(:company_card_type, conversion_tax: 10)
          first_card = FactoryBot.create(:card, cpf: '66268563670', points: 100, company_card_type: company)
          second_card = Card.create!(cpf: '50226428087', points: 100, company_card_type: company)
          request = { recharge: [{ cpf: first_card.cpf, value: 15 }, { cpf: second_card.cpf, value: 25 }] }
          patch '/api/v1/cards/recharge', params: request
          first_card.reload
          second_card.reload

          expect(response.status).to eq 200
          expect(response.content_type).to include 'application/json'
          json_response = response.parsed_body
          expect(json_response[0]['cpf']).to eq '66268563670'
          expect(json_response[0]['message']).to eq 'Recarga efetuada com sucesso'
          expect(json_response[1]['cpf']).to eq '50226428087'
          expect(json_response[1]['message']).to eq 'Recarga efetuada com sucesso'
          expect(first_card.points).to eq 117
          expect(second_card.points).to eq 128
        end

        it 'gera um deposito e um extrato para cada' do
          company = FactoryBot.create(:company_card_type, conversion_tax: 10)
          first_card = FactoryBot.create(:card, cpf: '66268563670', points: 100, company_card_type: company)
          second_card = Card.create!(cpf: '50226428087', points: 100, company_card_type: company)
          request = { recharge: [{ cpf: first_card.cpf, value: 15 }, { cpf: second_card.cpf, value: 25 }] }
          patch '/api/v1/cards/recharge', params: request
          first_card.reload
          second_card.reload
          first_card_deposit = Deposit.find(1)
          first_card_extract = Extract.find(1)
          second_card_deposit = Deposit.find(2)
          second_card_extract = Extract.find(2)

          expect(first_card_deposit.card).to eq first_card
          expect(first_card_extract.card_number).to eq first_card.number
          expect(first_card_deposit.amount).to eq 17
          expect(first_card_extract.value).to eq 17
          expect(second_card_deposit.card).to eq second_card
          expect(second_card_extract.card_number).to eq second_card.number
          expect(second_card_deposit.amount).to eq 28
          expect(second_card_extract.value).to eq 28
        end
      end

      context 'e recarregar um e falhar no outro' do
        it 'retorna uma mensagem de sucesso e outra de falha' do
          company = FactoryBot.create(:company_card_type, conversion_tax: 10)
          first_card = FactoryBot.create(:card, cpf: '66268563670', points: 100, company_card_type: company)
          second_card = Card.create!(cpf: '50226428087', points: 100, company_card_type: company, status: :inactive)
          request = { recharge: [{ cpf: first_card.cpf, value: 15 }, { cpf: second_card.cpf, value: 25 }] }
          patch '/api/v1/cards/recharge', params: request
          first_card.reload
          second_card.reload

          expect(response.status).to eq 200
          expect(response.content_type).to include 'application/json'
          json_response = response.parsed_body
          expect(json_response[0]['cpf']).to eq '66268563670'
          expect(json_response[0]['message']).to eq 'Recarga efetuada com sucesso'
          expect(json_response[1]['cpf']).to eq '50226428087'
          expect(json_response[1]['errors']).to eq 'Cartão não encontrado ou inativo'
          expect(first_card.points).to eq 117
          expect(second_card.points).to eq 100
        end

        it 'gera um deposito e um extrato para o cartão que foi recarregado' do
          company = FactoryBot.create(:company_card_type, conversion_tax: 10)
          first_card = FactoryBot.create(:card, cpf: '66268563670', points: 100, company_card_type: company)
          second_card = Card.create!(cpf: '50226428087', points: 100, company_card_type: company, status: :inactive)
          request = { recharge: [{ cpf: first_card.cpf, value: 15 }, { cpf: second_card.cpf, value: 25 }] }
          patch '/api/v1/cards/recharge', params: request
          first_card.reload
          second_card.reload

          first_card_deposit = Deposit.find(1)
          first_card_extract = Extract.find(1)
          second_card_deposit = Deposit.find_by(card: second_card)
          second_card_extract = Extract.find_by(card_number: second_card.number)

          expect(first_card_deposit.card).to eq first_card
          expect(first_card_extract.card_number).to eq first_card.number
          expect(second_card_deposit).to be_falsy
          expect(second_card_extract).to be_falsy
        end
      end
    end
  end
end
