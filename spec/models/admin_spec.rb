require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe 'Admin do register' do
    context '#invalid' do
      it 'when cpf is already in use' do
        Admin.create!(name: 'Jose da Silva', email: 'jose@punti.com', password: '123456',
                      password_confirmation: '123456', cpf: '56677883140')
        luiz = Admin.new(name: 'Luiz da Silva', email: 'luizs@punti.com', password: '123456',
                         password_confirmation: '123456', cpf: '56677883140')

        result = luiz.valid?

        expect(result).to eq false
      end

      it 'when cpf is invalid' do
        luiz = Admin.new(name: 'Luiz da Silva', email: 'luizs@punti.com', password: '123456',
                         password_confirmation: '123456', cpf: '23578998710')

        result = luiz.valid?

        expect(result).to eq false
      end

      it 'when name is empty' do
        luiz = Admin.new(name: '', email: 'luizs@punti.com', password: '123456',
                         password_confirmation: '123456', cpf: '23578998710')

        result = luiz.valid?

        expect(result).to eq false
      end

      it 'when name is less than 10 characters' do
        luiz = Admin.new(name: 'luiz', email: 'luizs@punti.com', password: '123456',
                         password_confirmation: '123456', cpf: '23578998710')

        result = luiz.valid?

        expect(result).to eq false
      end
    end
  end
end
