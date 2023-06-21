require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe 'validar status' do
    it 'status padrão pendente' do
      result = Payment.new

      expect(result.status).to eq 'pending'
    end
  end

  describe 'gera código aleatório' do
    it 'ao criar pagamento' do
      result = FactoryBot.create(:payment)
      result.save

      expect(result.code).not_to be_empty
      expect(result.code.length).to eq 10
    end
  end

  describe '#valid?' do
    it 'número do cartão não pode estar vazio' do
      payment = Payment.new(card_number: '')

      payment.valid?
      result = payment.errors.include?(:card_number)

      expect(result).to eq true
    end

    it 'valor final não pode estar vazio' do
      payment = Payment.new(final_value: '')

      payment.valid?
      result = payment.errors.include?(:final_value)

      expect(result).to eq true
    end

    it 'número do pedido não pode estar vazio' do
      payment = Payment.new(order_number: '')

      payment.valid?
      result = payment.errors.include?(:order_number)

      expect(result).to eq true
    end

    it 'valor total não pode estar vazio' do
      payment = Payment.new(total_value: '')

      payment.valid?
      result = payment.errors.include?(:total_value)

      expect(result).to eq true
    end

    it 'valor do desconto não pode estar vazio' do
      payment = Payment.new(descount_amount: '')

      payment.valid?
      result = payment.errors.include?(:descount_amount)

      expect(result).to eq true
    end

    it 'CPF não pode estar vazio' do
      payment = Payment.new(cpf: '')

      payment.valid?
      result = payment.errors.include?(:cpf)

      expect(result).to eq true
    end

    it 'status não pode estar vazio' do
      payment = Payment.new(status: '')

      payment.valid?
      result = payment.errors.include?(:status)

      expect(result).to eq true
    end

    it 'Data de pagamento não pode estar vazio' do
      payment = Payment.new(payment_date: '')

      payment.valid?
      result = payment.errors.include?(:payment_date)

      expect(result).to eq true
    end

    it 'código deve ser único' do
      allow(SecureRandom).to receive(:alphanumeric).and_return('5KIAMXNLUO')
      FactoryBot.create(:payment)

      allow(SecureRandom).to receive(:alphanumeric).and_return('5KIAMXNLUO')
      payment = Payment.new

      payment.valid?
      result = payment.errors.include?(:code)

      expect(result).to eq true
    end
  end

  describe 'validações de reprovação' do
    it 'para cartão inexistente' do
      FactoryBot.create(:error_message, description: 'Cartão informado não existe')
      payment = FactoryBot.create(:payment)
      
      errors = payment.errors_associations

      expect(errors.length).to eq 1
      expect(errors[0].error_message.description).to eq 'Cartão informado não existe'
    end

    it 'para cartão não ativo' do
      FactoryBot.create(:error_message, description: 'Cartão informado não existe')
      FactoryBot.create(:error_message, code: '002', description: 'Cartão não está ativo')
      allow(SecureRandom).to receive(:random_number).and_return('12345678912345678912')
      FactoryBot.create(:card, status: 'inactive', cpf: '66268563670')
      allow(SecureRandom).to receive(:alphanumeric).and_return('4521547859')
      payment = FactoryBot.create(:payment, card_number: '12345678912345678912', cpf: '02310635049')

      errors = payment.errors_associations

      expect(errors.length).to eq 1
      expect(errors[0].error_message.description).to eq 'Cartão não está ativo'
    end

    it 'para cartão não pertence ao CPF informado' do
      FactoryBot.create(:error_message, description: 'Cartão informado não existe')
      FactoryBot.create(:error_message, code: '002', description: 'Cartão não está ativo')
      FactoryBot.create(:error_message, code: '003', description: 'Cartão não pertence ao CPF informado')
      allow(SecureRandom).to receive(:random_number).and_return('12345678912345678912')
      FactoryBot.create(:card, cpf: '66268563670')
      allow(SecureRandom).to receive(:alphanumeric).and_return('4521547859')
      payment = FactoryBot.create(:payment, card_number: '12345678912345678912', cpf: '02310635049')

      errors = payment.errors_associations

      expect(errors.length).to eq 1
      expect(errors[0].error_message.description).to eq 'Cartão não pertence ao CPF informado'
    end

    it 'para valor final maior que o saldo do cartão' do
      FactoryBot.create(:error_message, description: 'Cartão informado não existe')
      FactoryBot.create(:error_message, code: '002', description: 'Cartão não está ativo')
      FactoryBot.create(:error_message, code: '003', description: 'Cartão não pertence ao CPF informado')
      FactoryBot.create(:error_message, code: '004', description: 'Valor da compra é maior que o saldo do cartão')
      allow(SecureRandom).to receive(:random_number).and_return('12345678912345678912')
      FactoryBot.create(:card, cpf: '66268563670', points: 50)
      allow(SecureRandom).to receive(:alphanumeric).and_return('4521547859')
      payment = FactoryBot.create(:payment, card_number: '12345678912345678912', cpf: '66268563670', final_value: 500)

      errors = payment.errors_associations

      expect(errors.length).to eq 1
      expect(errors[0].error_message.description).to eq 'Valor da compra é maior que o saldo do cartão'
    end

    it 'com mais de um erro' do
      FactoryBot.create(:error_message, description: 'Cartão informado não existe')
      FactoryBot.create(:error_message, code: '002', description: 'Cartão não está ativo')
      FactoryBot.create(:error_message, code: '003', description: 'Cartão não pertence ao CPF informado')
      FactoryBot.create(:error_message, code: '004', description: 'Valor da compra é maior que o saldo do cartão')
      allow(SecureRandom).to receive(:random_number).and_return('12345678912345678912')
      FactoryBot.create(:card, cpf: '66268563670', points: 50)
      allow(SecureRandom).to receive(:alphanumeric).and_return('4521547859')
      payment = FactoryBot.create(:payment, card_number: '12345678912345678912', cpf: '02310635049', final_value: 500)

      errors = payment.errors_associations

      expect(errors.length).to eq 2
      expect(errors[0].error_message.description).to eq 'Cartão não pertence ao CPF informado'
      expect(errors[1].error_message.description).to eq 'Valor da compra é maior que o saldo do cartão'
    end
  end
end
