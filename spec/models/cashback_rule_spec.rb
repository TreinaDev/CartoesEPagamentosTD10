require 'rails_helper'

RSpec.describe CashbackRule, type: :model do
  context '#valid?' do
    context 'uniqueness' do
      it 'deve retornar uma mensagem de erro, caso a regra de cashback já exista' do
        CashbackRule.create!(minimum_amount_points: 300, cashback_percentage: 9.99, days_to_use: 10)
        cashback_rule = CashbackRule.new(minimum_amount_points: 300, cashback_percentage: 9.99, days_to_use: 10)

        result = cashback_rule.valid?

        expect(result).to eq false
        expect(cashback_rule.errors[:cashback_percentage]).to include 'A regra de cashback já existe'
      end
    end

    context 'presence' do
      it 'deve retornar falso caso minimum_amount_points esteja vazio' do
        cashback_rule = CashbackRule.new(cashback_percentage: 9.99, days_to_use: 10)

        result = cashback_rule.valid?

        expect(result).to eq false
        expect(cashback_rule.errors.full_messages).to include 'Valor mínimo não é um número'
      end

      it 'deve retornar falso caso cashback_percentage esteja vazio' do
        cashback_rule = CashbackRule.new(minimum_amount_points: 300, days_to_use: 10)

        result = cashback_rule.valid?

        expect(result).to eq false
        expect(cashback_rule.errors.full_messages).to include 'Porcentagem de retorno não é um número'
      end

      it 'deve retornar falso caso days_to_use esteja vazio' do
        cashback_rule = CashbackRule.new(minimum_amount_points: 300, cashback_percentage: 9.99)

        result = cashback_rule.valid?

        expect(result).to eq false
        expect(cashback_rule.errors.full_messages).to include 'Deve ser válido por quantos dias? não é um número'
      end
    end

    context 'numericality' do
      it 'deve retornar falso caso minimum_amount_points seja um número menor que zero' do
        cashback_rule = CashbackRule.new(minimum_amount_points: -100, cashback_percentage: 9.99, days_to_use: 10)

        result = cashback_rule.valid?

        expect(result).to eq false
        expect(cashback_rule.errors.full_messages).to include 'Valor mínimo deve ser maior que 0'
      end

      it 'deve retornar falso caso minimum_amount_points não seja um número inteiro' do
        cashback_rule = CashbackRule.new(minimum_amount_points: 100.5, cashback_percentage: 9.99, days_to_use: 10)

        result = cashback_rule.valid?

        expect(result).to eq false
        expect(cashback_rule.errors.full_messages).to include 'Valor mínimo não é um número inteiro'
      end

      it 'deve retornar falso caso days_to_use seja um número menor que zero' do
        cashback_rule = CashbackRule.new(minimum_amount_points: 100, cashback_percentage: 9.99, days_to_use: -10)

        result = cashback_rule.valid?

        expect(result).to eq false
        expect(cashback_rule.errors.full_messages).to include 'Deve ser válido por quantos dias? deve ser maior que 0'
      end

      it 'deve retornar falso caso days_to_use não seja um número inteiro' do
        cashback_rule = CashbackRule.new(minimum_amount_points: 100, cashback_percentage: 9.99, days_to_use: 10.5)

        result = cashback_rule.valid?

        expect(result).to eq false
        expect(cashback_rule.errors.full_messages)
          .to include 'Deve ser válido por quantos dias? não é um número inteiro'
      end

      it 'deve retornar falso caso cashback_percentage seja um número menor que zero' do
        cashback_rule = CashbackRule.new(minimum_amount_points: 100, cashback_percentage: -9.99, days_to_use: 10)

        result = cashback_rule.valid?

        expect(result).to eq false
        expect(cashback_rule.errors.full_messages).to include 'Porcentagem de retorno deve ser maior que 0'
      end

      it 'deve retornar falso caso cashback_percentage seja um número maior ou igual a 100' do
        cashback_rule = CashbackRule.new(minimum_amount_points: 500, cashback_percentage: 100, days_to_use: 10)

        result = cashback_rule.valid?

        expect(result).to eq false
        expect(cashback_rule.errors.full_messages).to include 'Porcentagem de retorno deve ser menor que 100'
      end
    end
  end
end
