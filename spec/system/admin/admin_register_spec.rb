require 'rails_helper'

describe 'Administrador cria uma conta', type: :system do
  context 'sem sucesso' do
    it 'quando nome esta vazio' do
      visit root_path
      click_on 'Entrar'
      click_on 'Cadastrar'
      within('form') do
        fill_in 'Nome', with: ''
        fill_in 'CPF', with: '86882381208'
        fill_in 'E-mail', with: 'admin.luizq@punti.com'
        fill_in 'Senha', with: '123456'
        fill_in 'Confirme sua senha', with: '123456'
        click_on 'Cadastrar'
      end

      expect(page).to have_content 'Nome não pode ficar em branco'
      expect(page).to have_content 'Nome é muito curto (mínimo: 5 caracteres)'
    end

    it 'quando email não pertence ao domínio: punti.com' do
      visit root_path
      click_on 'Entrar'
      click_on 'Cadastrar'
      within('form') do
        fill_in 'Nome', with: ''
        fill_in 'CPF', with: '06909882733'
        fill_in 'E-mail', with: 'admin.luizq@email.com'
        fill_in 'Senha', with: '123456'
        fill_in 'Confirme sua senha', with: '123456'
        click_on 'Cadastrar'
      end

      expect(page).to have_content 'E-mail precisa pertencer ao domínio @punti.com'
    end

    it 'quando email já esta em uso' do
      Admin.create!(
        name: 'Maria Josefa Silva',
        cpf: '84045901418',
        email: 'j@punti.com',
        password: '123456',
        password_confirmation: '123456'
      )

      visit root_path
      click_on 'Entrar'
      click_on 'Cadastrar'
      within('form') do
        fill_in 'Nome', with: 'Luiz Quintanilha'
        fill_in 'CPF', with: '27438203816'
        fill_in 'E-mail', with: 'j@punti.com'
        fill_in 'Senha', with: '123456'
        fill_in 'Confirme sua senha', with: '123456'
        click_on 'Cadastrar'
      end

      expect(page).to have_content 'E-mail já está em uso'
    end

    it 'quando cpf é invalido' do
      visit root_path
      click_on 'Entrar'
      click_on 'Cadastrar'
      within('form') do
        fill_in 'Nome', with: 'Luiz Quintanilha'
        fill_in 'CPF', with: '11122233345'
        fill_in 'E-mail', with: 'admin@punti.com'
        fill_in 'Senha', with: '123456'
        fill_in 'Confirme sua senha', with: '123456'
        click_on 'Cadastrar'
      end

      expect(page).to have_content 'CPF inválido'
    end

    it 'quando cpf já esta em uso' do
      Admin.create(
        name: 'Maria Josefa Silva',
        cpf: '27413653346',
        email: 'josefa@punti.com',
        password: '123456',
        password_confirmation: '123456'
      )

      visit root_path
      click_on 'Entrar'
      click_on 'Cadastrar'
      within('form') do
        fill_in 'Nome', with: 'Luiz Quintanilha'
        fill_in 'CPF', with: '27413653346'
        fill_in 'E-mail', with: 'admin.luiz@punti.com'
        fill_in 'Senha', with: '123456'
        fill_in 'Confirme sua senha', with: '123456'
        click_on 'Cadastrar'
      end

      expect(page).to have_content 'CPF já está em uso'
    end

    it 'quando senha tem menos que 5 caracteres' do
      visit root_path
      click_on 'Entrar'
      click_on 'Cadastrar'
      within('form') do
        fill_in 'Nome', with: 'Admin'
        fill_in 'CPF', with: '06909882733'
        fill_in 'E-mail', with: 'admin.luizq@punti.com'
        fill_in 'Senha', with: '1234'
        fill_in 'Confirme sua senha', with: '1234'
        click_on 'Cadastrar'
      end

      expect(page).to have_content 'Não foi possível salvar administrador: 1 erro'
      expect(page).to have_content 'Senha é muito curto (mínimo: 6 caracteres)'
    end

    it 'quando senha e confirmação de senha não conferem' do
      visit root_path
      click_on 'Entrar'
      click_on 'Cadastrar'
      within('form') do
        fill_in 'Nome', with: 'Admin'
        fill_in 'CPF', with: '06909882733'
        fill_in 'E-mail', with: 'admin.luizq@punti.com'
        fill_in 'Senha', with: '654321'
        fill_in 'Confirme sua senha', with: '123465'
        click_on 'Cadastrar'
      end

      expect(page).to have_content 'Não foi possível salvar administrador: 1 erro'
      expect(page).to have_content 'Confirme sua senha não é igual a Senha'
    end
  end
end
