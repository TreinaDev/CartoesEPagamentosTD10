require 'rails_helper'

describe 'API de consulta do pagamento' do
  context 'GET /api/v1/payments?code=code_number' do
    it 'com sucesso' do
      payment = FactoryBot.create(:payment, order_number: '852369',
                                            total_value: 500,
                                            descount_amount: 50,
                                            final_value: 450,
                                            status: 'pending',
                                            cpf: '15756448506',
                                            card_number: '98765432165432198765',
                                            payment_date: Date.current)

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
      expect(json_response['code']).to eq payment.code
      expect(json_response['status']).to eq 'pending'
    end

    it 'retorna apenas o pagamento do codigo informado' do
      payment = FactoryBot.create(:payment, order_number: '852369',
                                            total_value: 500,
                                            descount_amount: 50,
                                            final_value: 450,
                                            status: 'pending',
                                            cpf: '15756448506',
                                            card_number: '98765432165432198765',
                                            payment_date: Date.current)

      FactoryBot.create(:payment, order_number: '456123',
                                  total_value: 300,
                                  descount_amount: 50,
                                  final_value: 250,
                                  status: 'pending',
                                  cpf: '04621165062',
                                  card_number: '87452147852365874125',
                                  payment_date: Date.current)

      get "/api/v1/payments?code=#{payment.code}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      json_response = [json_response]
      expect(json_response.length).to eq(1)
      expect(json_response[0]['order_number']).to eq '852369'
      expect(json_response[0]['total_value']).to eq 500
      expect(json_response[0]['descount_amount']).to eq 50
      expect(json_response[0]['final_value']).to eq 450
      expect(json_response[0]['cpf']).to eq '15756448506'
      expect(json_response[0]['card_number']).to eq '98765432165432198765'
      expect(json_response[0]['code']).to eq payment.code
      expect(json_response[0]['status']).to eq 'pending'
    end

    it 'retonar erro caso não encontre um código informado' do
      FactoryBot.create(:payment, order_number: '852369',
                                  total_value: 500,
                                  descount_amount: 50,
                                  final_value: 450,
                                  status: 'pending',
                                  cpf: '15756448506',
                                  card_number: '98765432165432198765',
                                  payment_date: Date.current)
      code = 'DW4NWMSBWJ'

      get "/api/v1/payments?code=#{code}"

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      expect(response.body).to include 'Erro de entidade não encontrada'
    end

    it 'retorna erro em caso de falha interna' do
      allow(Payment).to receive(:find_by!).and_raise(ActiveRecord::ActiveRecordError)

      payment = FactoryBot.create(:payment, order_number: '852369',
                                            total_value: 500,
                                            descount_amount: 50,
                                            final_value: 450,
                                            status: 'pending',
                                            cpf: '15756448506',
                                            card_number: '98765432165432198765',
                                            payment_date: Date.current)

      get "/api/v1/payments?#{payment.code}"

      expect(response.status).to eq 500
    end
  end
end
