require 'rails_helper'

describe 'Admin do create a count', type: :system do
  context 'unsucessfully' do
    it 'when the name is empty?' do
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

    it 'when email is not the momain @punti.com' do
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

    it 'when email is already in use' do
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

    it 'when cpf is invalid' do
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

    it 'when cpf is already in use' do
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
  end
end
