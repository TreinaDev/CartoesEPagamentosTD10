require 'rails_helper'

describe 'API de consulta do pagamento' do
  context 'GET /api/v1/payments?code=code_number' do
    it 'com sucesso' do
      payment = Payment.create!(order_number: '852369',
                                code: 'EKMZVUVIWU',
                                total_value: 500,
                                descount_amount: 50,
                                final_value: 450,
                                status: 'pending',
                                cpf: '15756448506',
                                card_number: '98765432165432198765')

      get "/api/v1/payments?code=#{payment.code}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['order_number']).to eq '852369'
      expect(json_response['total_value']).to eq 500
      expect(json_response['descount_amount']).to eq 50
      expect(json_response['final_value']).to eq 450
      expect(json_response['cpf']).to eq '15756448506'
      expect(json_response['card_number']).to eq '98765432165432198765'
      expect(json_response['code']).to eq 'EKMZVUVIWU'
      expect(json_response['status']).to eq 'pending'
    end

    it 'retorna apenas o pagamento do codigo informado' do
      payment = Payment.create!(order_number: '852369',
                                code: 'EKMZVUVIWU',
                                total_value: 500,
                                descount_amount: 50,
                                final_value: 450,
                                status: 'pending',
                                cpf: '15756448506',
                                card_number: '98765432165432198765')

      Payment.create!(order_number: '456123',
                      code: 'T37PD3ARY0',
                      total_value: 300,
                      descount_amount: 50,
                      final_value: 250,
                      status: 'pending',
                      cpf: '04621165062',
                      card_number: '87452147852365874125')

      get "/api/v1/payments?code=#{payment.code}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response['order_number']).to eq '852369'
      expect(json_response['total_value']).to eq 500
      expect(json_response['descount_amount']).to eq 50
      expect(json_response['final_value']).to eq 450
      expect(json_response['cpf']).to eq '15756448506'
      expect(json_response['card_number']).to eq '98765432165432198765'
      expect(json_response['code']).to eq 'EKMZVUVIWU'
      expect(json_response['status']).to eq 'pending'
    end

    it 'retonar erro caso não encontre um código informado' do
      Payment.create!(order_number: '852369',
                      code: 'EKMZVUVIWU',
                      total_value: 500,
                      descount_amount: 50,
                      final_value: 450,
                      status: 'pending',
                      cpf: '15756448506',
                      card_number: '98765432165432198765')
      code = 'DW4NWMSBWJ'

      get "/api/v1/payments?code=#{code}"

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
    end

    it 'retorna erro em caso de falha interna' do
      allow(Payment).to receive(:find_by!).and_raise(ActiveRecord::ActiveRecordError)

      payment = Payment.create!(order_number: '852369',
                                code: 'EKMZVUVIWU',
                                total_value: 500,
                                descount_amount: 50,
                                final_value: 450,
                                status: 'pending',
                                cpf: '15756448506',
                                card_number: '98765432165432198765')

      get "/api/v1/payments?#{payment.code}"

      expect(response.status).to eq 500
    end
  end
end
