require 'rails_helper'

RSpec.describe CardType, type: :model do
  describe '#valid?' do
    context 'campo nome ' do
      it 'vazio' do
        card_type = CardType.new(name: '', icon: 'https://i.imgur.com/YmQ9jRN.png', start_points: 100)

        expect(card_type.valid?).to eq false
        expect(card_type.errors.full_messages[0]).to eq 'Nome não pode ficar em branco'
      end

      it 'não é unico' do
        FactoryBot.create(:card_type)
        second_card_type = CardType.new(name: 'Premium', icon: 'https://i.imgur.com/YmQ9jRN.png', start_points: 50)
        expect(second_card_type.valid?).to eq false
        expect(second_card_type.errors.full_messages[0]).to eq 'Nome já está em uso'
      end
    end

    context 'campo icone ' do
      it 'vazio' do
        card_type = CardType.new(name: 'Premium', icon: '', start_points: 100)

        expect(card_type.valid?).to eq false
        expect(card_type.errors.full_messages[0]).to eq 'Ícone não pode ficar em branco'
      end

      it 'não é único' do
        FactoryBot.create(:card_type)
        second_card_type = CardType.new(name: 'Black', icon: 'https://i.imgur.com/YmQ9jRN.png', start_points: 50)

        expect(second_card_type.valid?).to eq false
        expect(second_card_type.errors.full_messages[0]).to eq 'Ícone já está em uso'
      end
    end

    it 'start_points vazio' do
      FactoryBot.build(:card_type, start_points: '')

      expect(card_type.valid?).to eq false
      expect(card_type.errors.full_messages[0]).to eq 'Pontos iniciais não pode ficar em branco'
    end
  end
end
