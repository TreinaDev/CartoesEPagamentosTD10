require 'rails_helper'

RSpec.describe Card, type: :model do
  describe '#valid?' do
    it 'falso quando o cpf é vazio' do
      card_type = FactoryBot.create(:card_type)
      company_card_type = CompanyCardType.create!(cnpj: '71.223.406/0001-81', card_type:, conversion_tax: '9.99')
      card = Card.new(cpf: '', company_card_type:)

      result = card.valid?

      expect(result).to eq false
      expect(card.errors.full_messages).to include 'CPF não pode ficar em branco'
    end

    it 'falso quando o tipo do cartão é vazio' do
      card = Card.new(cpf: '78956470081')

      result = card.valid?

      expect(result).to eq false
      expect(card.errors.full_messages).to include 'Tipo de cartão da empresa é obrigatório(a)'
    end

    it 'falso quando já existe um cartão ativo com mesmo CPF' do
      card_type = FactoryBot.create(:card_type)
      company_card_type = CompanyCardType.create!(cnpj: '71.223.406/0001-81', card_type:, conversion_tax: '9.99')
      Card.create!(cpf: '78956470081', company_card_type:)
      card = Card.new(cpf: '78956470081', company_card_type:)

      result = card.valid?

      expect(result).to eq false
      expect(card.errors.full_messages).to include 'CPF já possui um cartão ativo'
    end

    it 'falso quando o tipo de cartão não está disponível' do
      card_type = FactoryBot.create(:card_type)
      company_card_type = CompanyCardType.create!(cnpj: '71.223.406/0001-81', card_type:, conversion_tax: '9.99',
                                                  status: :inactive)
      card = Card.new(cpf: '78956470081', company_card_type:)

      result = card.valid?

      expect(result).to eq false
      expect(card.errors.full_messages).to include 'Tipo de cartão da empresa não está disponível'
    end
  end

  describe 'gera um número aleatório' do
    it 'ao criar um novo cartão' do
      card_type = FactoryBot.create(:card_type)
      company_card_type = CompanyCardType.create!(cnpj: '71.223.406/0001-81', card_type:, conversion_tax: '9.99')
      card = Card.new(cpf: '78956470081', company_card_type:)

      card.save!
      result = card.number

      expect(result).not_to be_empty
      expect(result.length).to eq 20
    end

    it 'de forma única' do
      card_type = FactoryBot.create(:card_type)
      company_card_type = CompanyCardType.create!(cnpj: '71.223.406/0001-81', card_type:, conversion_tax: '9.99')
      first_card = Card.create!(cpf: '78956470081', company_card_type:)
      second_card = Card.new(cpf: '97988819070', company_card_type:)

      second_card.save!

      expect(second_card.number).not_to eq first_card.number
    end

    it 'e não deve ser modificado' do
      card_type = FactoryBot.create(:card_type)
      company_card_type = CompanyCardType.create!(cnpj: '71.223.406/0001-81', card_type:, conversion_tax: '9.99')
      card = Card.create!(cpf: '78956470081', company_card_type:)
      original_number = card.number

      card.update!(status: :inactive)

      expect(card.number).to eq original_number
    end
  end

  describe 'gera a quantidade de pontos iniciais' do
    it 'ao criar um novo cartão' do
      card_type = FactoryBot.create(:card_type)
      company_card_type = CompanyCardType.create!(cnpj: '71.223.406/0001-81', card_type:, conversion_tax: '9.99')
      card = Card.new(cpf: '78956470081', company_card_type:)

      card.save!
      result = card.points

      expect(result).to eq company_card_type.card_type.start_points
    end
  end

  describe 'gera com status ativo' do
    it 'ao criar um novo cartão' do
      card_type = FactoryBot.create(:card_type)
      company_card_type = CompanyCardType.create!(cnpj: '71.223.406/0001-81', card_type:, conversion_tax: '9.99')
      card = Card.new(cpf: '78956470081', company_card_type:)

      card.save!
      result = card.status

      expect(result).to eq 'active'
    end
  end

  describe 'com status bloqueado' do
    it 'não permite atualização' do
      card_type = FactoryBot.create(:card_type)
      company_card_type = CompanyCardType.create!(cnpj: '71.223.406/0001-81', card_type:, conversion_tax: '9.99')
      card = Card.create!(cpf: '78956470081', status: :blocked, company_card_type:)

      result = card.update(status: :active)

      expect(result).to eq false
      expect(card.errors.full_messages).to include 'Status bloqueado não permite alterações no cartão'
    end
  end
end
