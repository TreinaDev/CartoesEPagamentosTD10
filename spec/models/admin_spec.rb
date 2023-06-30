require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe 'Admin se registra' do
    context '#invalid' do
      it 'e o cpf já está em uso' do
        Admin.create!(name: 'Jose da Silva', email: 'jose@punti.com', password: '123456',
                      password_confirmation: '123456', cpf: '56677883140')
        admin = Admin.new(name: 'Luiz da Silva', email: 'luizs@punti.com', password: '123456',
                          password_confirmation: '123456', cpf: '56677883140')

        expect(admin.valid?).to eq false
        expect(admin.errors.full_messages[0]).to eq 'CPF já está em uso'
      end

      it 'e o cpf é inválido' do
        admin = Admin.new(name: 'Luiz da Silva', email: 'luizs@punti.com', password: '123456',
                          password_confirmation: '123456', cpf: '23578998710')

        expect(admin.valid?).to eq false
        expect(admin.errors.full_messages[0]).to eq 'CPF inválido'
      end

      it 'e o nome está vazio' do
        admin = Admin.new(name: '', email: 'luizs@punti.com', password: '123456',
                          password_confirmation: '123456', cpf: '23578998710')

        expect(admin.valid?).to eq false
        expect(admin.errors.full_messages[0]).to eq 'Nome não pode ficar em branco'
      end

      it 'e o nome tem menos de 5 caracteres' do
        admin = Admin.new(name: 'luiz', email: 'luizs@punti.com', password: '123456',
                          password_confirmation: '123456', cpf: '23578998710')

        expect(admin.valid?).to eq false
        expect(admin.errors.full_messages[0]).to eq 'Nome é muito curto (mínimo: 5 caracteres)'
      end

      it 'e a senha tem menos que 6 caracteres' do
        admin = Admin.new(name: 'luiz', email: 'luizs@punti.com', password: '1234',
                          password_confirmation: '1234', cpf: '23578998710')

        expect(admin.valid?).to eq false
        expect(admin.errors.full_messages[0]).to eq 'Senha é muito curto (mínimo: 6 caracteres)'
      end

      it 'e a senha e confirmação de senha não conferem' do
        admin = Admin.new(name: 'luiz', email: 'luizs@punti.com', password: '654321',
                          password_confirmation: '123456', cpf: '23578998710')

        expect(admin.valid?).to eq false
        expect(admin.errors.full_messages[0]).to eq 'Confirme sua senha não é igual a Senha'
      end
    end
  end
end
