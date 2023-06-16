require 'rails_helper'

RSpec.describe CardType, type: :model do
  describe '#valid?' do
    context 'campo nome' do
      it 'vazio' do
        card_type = FactoryBot.build(:card_type, name: '')

        expect(card_type.valid?).to eq false
        expect(card_type.errors.full_messages[0]).to eq 'Nome não pode ficar em branco'
      end

      it 'não é unico' do
        FactoryBot.create(:card_type)
        gold_img = Rails.root.join('spec', 'support', 'images', 'gold.svg')
        second_card_type = FactoryBot.build(:card_type, name: 'Premium')
        second_card_type.icon.attach(
          io: gold_img.open,
          filename: 'gold.svg',
          content_type: 'image/svg+xml'
        )
        expect(second_card_type.valid?).to eq false
        expect(second_card_type.errors.full_messages[0]).to eq 'Nome já está em uso'
      end
    end

    context 'campo icone' do
      it 'vazio' do
        card_type = CardType.new(name: 'Premium', start_points: 100)

        expect(card_type.valid?).to eq false
        expect(card_type.errors.full_messages[0]).to eq 'Ícone não pode ficar em branco'
      end
    end

    it 'start_points vazio' do
      card_type = FactoryBot.build(:card_type, start_points: '')

      expect(card_type.valid?).to eq false
      expect(card_type.errors.full_messages[0]).to eq 'Pontos iniciais não pode ficar em branco'
    end
  end
end
