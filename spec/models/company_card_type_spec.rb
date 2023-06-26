require 'rails_helper'

RSpec.describe CompanyCardType, type: :model do
  describe '#valid?' do
    context 'combinação de tipo de cartão e CNPJ' do
      it 'não é única' do
        card_type = FactoryBot.create(:card_type)
        FactoryBot.create(:company_card_type, card_type:)
        company_card_type = FactoryBot.build(:company_card_type, card_type:)

        expect(company_card_type.valid?).to eq false
        expect(company_card_type.errors.full_messages).to include 'Tipo de cartão já está em uso'
      end
    end

    context 'campo CNPJ' do
      it 'não pode estar vazio' do
        company_card_type = FactoryBot.build(:company_card_type, cnpj: '')

        expect(company_card_type.valid?).to eq false
        expect(company_card_type.errors.full_messages).to include 'CNPJ não pode ficar em branco'
      end
    end

    context 'Taxa de conversão' do
      it 'não pode estar vazio' do
        company_card_type = FactoryBot.build(:company_card_type, conversion_tax: '')

        expect(company_card_type.valid?).to eq false
        expect(company_card_type.errors.full_messages).to include 'Taxa de conversão não pode ficar em branco'
      end

      it 'não pode ser uma string' do
        company_card_type = FactoryBot.build(:company_card_type, conversion_tax: 'string aleatória')

        expect(company_card_type.valid?).to eq false
        expect(company_card_type.errors.full_messages).to include 'Taxa de conversão não é um número'
      end

      it 'não pode ser menor que 0' do
        company_card_type = FactoryBot.build(:company_card_type, conversion_tax: '-5')

        expect(company_card_type.valid?).to eq false
        expect(company_card_type.errors.full_messages).to include 'Taxa de conversão deve ser maior que 0'
      end
    end
  end
end
