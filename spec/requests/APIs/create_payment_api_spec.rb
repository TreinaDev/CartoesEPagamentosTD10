require 'rails_helper'

describe 'API para criação de payment' do
  context 'POST /api/vi/payments' do
    it 'com sucesso' do
      FactoryBot.create(:card)

      payment = { payment: { order_number: '123246', total_value: 300,
                             descount_amount: 50, final_value: 250,
                             cpf: '12193448000158', card_number: '12345678912345678912',
                             payment_date: Date.current } }

      allow(SecureRandom).to receive(:alphanumeric).and_return('5KIAMXNLUO')

      post '/api/v1/payments', params: payment

      expect(response.status).to eq 201
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['status']).to eq 'pending'
      expect(json_response['code']).to eq '5KIAMXNLUO'
      expect(json_response['order_number']).to eq '123246'
      expect(json_response['total_value']).to eq 300
      expect(json_response['descount_amount']).to eq 50
      expect(json_response['final_value']).to eq 250
      expect(json_response['cpf']).to eq '12193448000158'
      expect(json_response['card_number']).to eq '12345678912345678912'
      expect(json_response['payment_date']).to eq Date.current.strftime('%Y-%m-%d')
    end

    it 'com falha' do
      payment = { payment: {} }

      post '/api/v1/payments', params: payment

      expect(response.status).to eq 400
      expect(response.body).to include 'Erro nos parâmetros enviados'
      expect(response.content_type).to include 'application/json'
    end

    it 'retorna erro em caso de falha interna' do
      FactoryBot.create(:card)

      payment = { payment: { order_number: '123246', total_value: 300,
                             descount_amount: 50, final_value: 250,
                             cpf: '12193448000158', card_number: '12345678912345678912',
                             payment_date: Date.current } }

      allow(SecureRandom).to receive(:alphanumeric).and_return('5KIAMXNLUO')
      allow(Payment).to receive(:new).and_raise(ActiveRecord::ActiveRecordError)

      post '/api/v1/payments', params: payment

      expect(response.status).to eq 500
    end

    it 'falha se não recebe parâmetros obrigatórios' do
      payment = { payment: { order_number: '', total_value: '',
                             descount_amount: '', final_value: '',
                             cpf: '', card_number: '',
                             payment_date: '' } }

      post '/api/v1/payments', params: payment

      expect(response.status).to eq 412
      expect(response.body).to include 'Número do pedido não pode ficar em branco'
      expect(response.body).to include 'Valor total não pode ficar em branco'
      expect(response.body).to include 'Valor do desconto não pode ficar em branco'
      expect(response.body).to include 'Valor final não pode ficar em branco'
      expect(response.body).to include 'CPF não pode ficar em branco'
      expect(response.body).to include 'Número do cartão não pode ficar em branco'
      expect(response.body).to include 'Data de pagamento não pode ficar em branco'
    end
  end
end
