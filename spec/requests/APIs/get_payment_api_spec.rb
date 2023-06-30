require 'rails_helper'

describe 'API de consulta do pagamento' do
  context 'GET /api/v1/payments/by_cpf?cpf=cpf' do
    it 'e retorna multiplos pagamentos com sucesso' do
      FactoryBot.create(:card, cpf: '15756448506')
      payment = FactoryBot.create(:payment, order_number: '852369',
                                            total_value: 500,
                                            descount_amount: 50,
                                            final_value: 450,
                                            status: 'pending',
                                            cpf: '15756448506',
                                            card_number: '98765432165432198765',
                                            payment_date: Date.current)
      payment2 = FactoryBot.create(:payment, order_number: '552369',
                                             total_value: 300,
                                             descount_amount: 50,
                                             final_value: 250,
                                             status: 'pending',
                                             cpf: '15756448506',
                                             card_number: '98765432165432198765',
                                             payment_date: 1.day.ago)

      get "/api/v1/payments/by_cpf?cpf=#{payment.cpf}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response[0]['payment_date']).to eq Time.zone.today.strftime('%Y-%m-%d')
      expect(json_response[0]['order_number']).to eq '852369'
      expect(json_response[0]['total_value']).to eq 500
      expect(json_response[0]['descount_amount']).to eq 50
      expect(json_response[0]['final_value']).to eq 450
      expect(json_response[0]['cpf']).to eq '15756448506'
      expect(json_response[0]['card_number']).to eq '98765432165432198765'
      expect(json_response[0]['code']).to eq payment.code
      expect(json_response[0]['status']).to eq 'pending'
      expect(json_response[1]['payment_date']).to eq 1.day.ago.strftime('%Y-%m-%d')
      expect(json_response[1]['order_number']).to eq '552369'
      expect(json_response[1]['total_value']).to eq 300
      expect(json_response[1]['descount_amount']).to eq 50
      expect(json_response[1]['final_value']).to eq 250
      expect(json_response[1]['cpf']).to eq '15756448506'
      expect(json_response[1]['card_number']).to eq '98765432165432198765'
      expect(json_response[1]['code']).to eq payment2.code
      expect(json_response[1]['status']).to eq 'pending'
    end

    it 'e retorna um único pagamento com sucesso' do
      FactoryBot.create(:card, cpf: '15756448506')
      payment = FactoryBot.create(:payment, order_number: '852369',
                                            total_value: 500,
                                            descount_amount: 50,
                                            final_value: 450,
                                            status: 'pending',
                                            cpf: '15756448506',
                                            card_number: '98765432165432198765',
                                            payment_date: Date.current)

      get "/api/v1/payments/by_cpf?cpf=#{payment.cpf}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response.length).to eq(1)
      expect(json_response[0]['payment_date']).to eq Time.zone.today.strftime('%Y-%m-%d')
      expect(json_response[0]['order_number']).to eq '852369'
      expect(json_response[0]['total_value']).to eq 500
      expect(json_response[0]['descount_amount']).to eq 50
      expect(json_response[0]['final_value']).to eq 450
      expect(json_response[0]['cpf']).to eq '15756448506'
      expect(json_response[0]['card_number']).to eq '98765432165432198765'
      expect(json_response[0]['code']).to eq payment.code
      expect(json_response[0]['status']).to eq 'pending'
    end

    it 'e não retorna pagamentos de outra pessoa' do
      FactoryBot.create(:card, cpf: '15756448506')
      payment = FactoryBot.create(:payment, order_number: '852369',
                                            total_value: 500,
                                            descount_amount: 50,
                                            final_value: 450,
                                            status: 'pending',
                                            cpf: '15756448506',
                                            card_number: '98765432165432198765',
                                            payment_date: Date.current)
      payment2 = FactoryBot.create(:payment, order_number: '963369',
                                             total_value: 300,
                                             descount_amount: 50,
                                             final_value: 250,
                                             status: 'pending',
                                             cpf: '15756448506',
                                             card_number: '98765432165432198765',
                                             payment_date: 1.day.ago)
      FactoryBot.create(:payment, order_number: '653369',
                                  total_value: 300,
                                  descount_amount: 50,
                                  final_value: 250,
                                  status: 'pending',
                                  cpf: '64256448506',
                                  card_number: '98765432165432198765',
                                  payment_date: 1.day.ago)

      get "/api/v1/payments/by_cpf?cpf=#{payment.cpf}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response.length).to eq(2)
      expect(json_response[0]['payment_date']).to eq Time.zone.today.strftime('%Y-%m-%d')
      expect(json_response[0]['order_number']).to eq '852369'
      expect(json_response[0]['total_value']).to eq 500
      expect(json_response[0]['descount_amount']).to eq 50
      expect(json_response[0]['final_value']).to eq 450
      expect(json_response[0]['cpf']).to eq '15756448506'
      expect(json_response[0]['card_number']).to eq '98765432165432198765'
      expect(json_response[0]['code']).to eq payment.code
      expect(json_response[0]['status']).to eq 'pending'
      expect(json_response[1]['payment_date']).to eq 1.day.ago.strftime('%Y-%m-%d')
      expect(json_response[1]['order_number']).to eq '963369'
      expect(json_response[1]['total_value']).to eq 300
      expect(json_response[1]['descount_amount']).to eq 50
      expect(json_response[1]['final_value']).to eq 250
      expect(json_response[1]['cpf']).to eq '15756448506'
      expect(json_response[1]['card_number']).to eq '98765432165432198765'
      expect(json_response[1]['code']).to eq payment2.code
      expect(json_response[1]['status']).to eq 'pending'
    end

    it 'e falha pois esse cpf não possuí cartão' do
      payment = FactoryBot.create(:payment, order_number: '852369',
                                            total_value: 500,
                                            descount_amount: 50,
                                            final_value: 450,
                                            status: 'pending',
                                            cpf: '15756448506',
                                            card_number: '98765432165432198765',
                                            payment_date: Date.current)

      get "/api/v1/payments/by_cpf?cpf=#{payment.cpf}"

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      expect(response.body).to include 'Erro de entidade não encontrada'
    end

    it 'e retorna um array vazio pois esse cpf não possui nenhum pagamento' do
      card = FactoryBot.create(:card, cpf: '15756448506')

      get "/api/v1/payments/by_cpf?cpf=#{card.cpf}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response.length).to eq(0)
    end
  end

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

      get "/api/v1/payments/#{payment.code}"

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

    it 'com sucesso um pagamento reprovado com uma mensagem de erro' do
      payment = FactoryBot.create(:payment, order_number: '852369',
                                            total_value: 500,
                                            descount_amount: 50,
                                            final_value: 450,
                                            status: 'pending',
                                            cpf: '15756448506',
                                            card_number: '98765432165432198765',
                                            payment_date: Date.current)
      payment.status = :rejected
      payment.save
      get "/api/v1/payments/#{payment.code}"

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
      expect(json_response['status']).to eq 'rejected'
      expect(json_response['error']).to eq 'O pagamento não pode ser concluído, contate a aplicação de cartões'
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

      get "/api/v1/payments/#{payment.code}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = response.parsed_body
      expect(json_response.is_a?(Array)).to eq(false)
      expect(json_response['order_number']).to eq '852369'
      expect(json_response['total_value']).to eq 500
      expect(json_response['descount_amount']).to eq 50
      expect(json_response['final_value']).to eq 450
      expect(json_response['cpf']).to eq '15756448506'
      expect(json_response['card_number']).to eq '98765432165432198765'
      expect(json_response['code']).to eq payment.code
      expect(json_response['status']).to eq 'pending'
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

      get "/api/v1/payments/#{code}"

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

      get "/api/v1/payments/#{payment.code}"

      expect(response.status).to eq 500
    end
  end
end
