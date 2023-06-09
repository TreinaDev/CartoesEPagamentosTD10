require 'rails_helper'

RSpec.describe Card, type: :model do
  describe '#valid?' do
    it 'falso quando o cpf é vazio' do
      company_card_type = FactoryBot.create(:company_card_type)
      card = Card.new(cpf: '', company_card_type:)

      result = card.valid?

      expect(result).to eq false
    end

    it 'falso quando o tipo do cartão é vazio' do
      card = Card.new(cpf: '78956470081')

      result = card.valid?

      expect(result).to eq false
    end

    it 'falso quando já existe um cartão atico com mesmo CPF' do
      company_card_type = FactoryBot.create(:company_card_type)
      Card.create!(cpf: '78956470081', company_card_type:)
      card = Card.new(cpf: '78956470081', company_card_type:)

      result = card.valid?

      expect(result).to eq false
    end
  end

  describe 'gera um número aleatório' do
    it 'ao criar um novo cartão' do
      company_card_type = FactoryBot.create(:company_card_type)
      card = Card.new(cpf: '78956470081', company_card_type:)

      card.save!
      result = card.number

      expect(result).not_to be_empty
      expect(result.length).to eq 20
    end

    it 'de forma única' do
      company_card_type = FactoryBot.create(:company_card_type)
      first_card = Card.create!(cpf: '78956470081', company_card_type:)
      second_card = Card.new(cpf: '97988819070', company_card_type:)

      second_card.save!

      expect(second_card.number).not_to eq first_card.number
    end

    it 'e não deve ser modificado' do
      company_card_type = FactoryBot.create(:company_card_type)
      card = Card.create!(cpf: '78956470081', company_card_type:)
      original_number = card.number

      card.update!(status: :inactive)

      expect(card.number).to eq original_number
    end
  end

  describe 'gera a quantidade de pontos iniciais' do
    it 'ao criar um novo cartão' do
      company_card_type = FactoryBot.create(:company_card_type)
      card = Card.new(cpf: '78956470081', company_card_type:)

      card.save!
      result = card.points

      expect(result).to eq company_card_type.card_type.start_points
    end
  end

  describe 'gera com status ativo' do
    it 'ao criar um novo cartão' do
      company_card_type = FactoryBot.create(:company_card_type)
      card = Card.new(cpf: '78956470081', company_card_type:)

      card.save!
      result = card.status

      expect(result).to eq 'active'
    end
  end
end
