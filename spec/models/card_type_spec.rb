require 'rails_helper'

RSpec.describe CardType, type: :model do
  describe '#valid?' do

    context 'com campo vazio:' do
      
      it 'nome' do
        card_type = CardType.new(name:'',icon:'https://i.imgur.com/YmQ9jRN.png',start_points: 100)

        expect(card_type.valid?).to eq false
        expect(card_type.errors.full_messages[0]).to eq 'Nome não pode ficar em branco'
      end

      it 'icone' do 
        card_type = CardType.new(name:'Premium',icon:'',start_points: 100)

        expect(card_type.valid?).to eq false
        expect(card_type.errors.full_messages[0]).to eq 'Ícone não pode ficar em branco'
      end

      it 'start_points' do 
        card_type = CardType.new(name:'Premium',icon:'https://i.imgur.com/YmQ9jRN.png',start_points: '')

        expect(card_type.valid?).to eq false
        expect(card_type.errors.full_messages[0]).to eq 'Pontos iniciais não pode ficar em branco'
      end

    end

    context 'campo único:' do

      it 'nome' do
        first_card_type = FactoryBot.create(:card_type)
        second_card_type = CardType.new(name:'Premium',icon:'https://i.imgur.com/YmQ9jRN.png',start_points: 50)

        expect(second_card_type.valid?).to eq false
        expect(second_card_type.errors.full_messages[0]).to eq 'Nome já está em uso'
      end

    end

  end
end
