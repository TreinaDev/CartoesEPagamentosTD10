require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe 'Admin se registra' do
    context '#invalid' do
      it 'e o cpf já está em uso' do
        Admin.create!(name: 'Jose da Silva', email: 'jose@punti.com', password: '123456',
                      password_confirmation: '123456', cpf: '56677883140')
        luiz = Admin.new(name: 'Luiz da Silva', email: 'luizs@punti.com', password: '123456',
                         password_confirmation: '123456', cpf: '56677883140')

        result = luiz.valid?

        expect(result).to eq false
      end

      it 'e o cpf é inválido' do
        luiz = Admin.new(name: 'Luiz da Silva', email: 'luizs@punti.com', password: '123456',
                         password_confirmation: '123456', cpf: '23578998710')

        result = luiz.valid?

        expect(result).to eq false
      end

      it 'e o nome está vazio' do
        luiz = Admin.new(name: '', email: 'luizs@punti.com', password: '123456',
                         password_confirmation: '123456', cpf: '23578998710')

        result = luiz.valid?

        expect(result).to eq false
      end

      it 'e o nome tem menos de 10 caracteres' do
        luiz = Admin.new(name: 'luiz', email: 'luizs@punti.com', password: '123456',
                         password_confirmation: '123456', cpf: '23578998710')

        result = luiz.valid?

        expect(result).to eq false
      end
    end
  end
end
