require 'rails_helper'

RSpec.describe ErrorMessage, type: :model do
  describe '#valid?' do
    it 'descrição não pode estar vazia' do
      error = ErrorMessage.new(description: '')

      error.valid?
      result = error.errors.full_messages.include?('Descrição não pode ficar em branco')

      expect(result).to eq true
    end

    it 'código não pode estar vazio' do
      error = ErrorMessage.new(code: '')

      error.valid?
      result = error.errors.full_messages.include?('Código não pode ficar em branco')

      expect(result).to eq true
    end

    it 'código deve ser único' do
      FactoryBot.create(:error_message, code: '001')
      error = ErrorMessage.new(code: '001')

      error.valid?
      result = error.errors.full_messages.include?('Código já está em uso')

      expect(result).to eq true
    end

    it 'código deve ter 3 caracteres' do
      error = ErrorMessage.new(code: '32165416545')

      error.valid?
      result = error.errors.full_messages.include?('Código não possui o tamanho esperado (3 caracteres)')

      expect(result).to eq true
    end
  end
end
