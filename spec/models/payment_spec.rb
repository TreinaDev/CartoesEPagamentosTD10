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

    it 'valor final não pode estar vazio' do
      payment = Payment.new(final_value: '')

      payment.valid?
      result = payment.errors.include?(:final_value)

      expect(result).to eq true
    end

    it 'número do cartão não pode estar vazio' do
      payment = Payment.new(card_number: '')

      payment.valid?
      result = payment.errors.include?(:card_number)

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

    it 'falha caso número do cartão não seja igual a 20 caracteres' do
      payment = Payment.new(card_number: '123456789123456789411')

      payment.valid?
      result = payment.errors.include?(:card_number)

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
end
