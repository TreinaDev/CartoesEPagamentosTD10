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

      result = payment.valid?

      expect(result).to eq false
    end

    it 'valor total não pode estar vazio' do
      payment = Payment.new(total_value: '')

      result = payment.valid?

      expect(result).to eq false
    end

    it 'valor do desconto não pode estar vazio' do
      payment = Payment.new(descount_amount: '')

      result = payment.valid?

      expect(result).to eq false
    end

    it 'valor final não pode estar vazio' do
      payment = Payment.new(final_value: '')

      result = payment.valid?

      expect(result).to eq false
    end

    it 'número do cartão não pode estar vazio' do
      payment = Payment.new(card_number: '')

      result = payment.valid?

      expect(result).to eq false
    end

    it 'CPF não pode estar vazio' do
      payment = Payment.new(cpf: '')

      result = payment.valid?

      expect(result).to eq false
    end

    it 'status não pode estar vazio' do
      payment = Payment.new(status: '')

      result = payment.valid?

      expect(result).to eq false
    end

    it 'código não pode estar vazio' do
      payment = Payment.new(code: '')

      result = payment.valid?

      expect(result).to eq false
    end

    it 'Data de pagamento não pode estar vazio' do
      payment = Payment.new(payment_date: '')

      result = payment.valid?

      expect(result).to eq false
    end

    it 'falha caso número do cartão não seja igual a 20 caracteres' do
      payment = Payment.new(card_number: '123456789123456789411')

      result = payment.valid?

      expect(result).to eq false
    end
  end
end
