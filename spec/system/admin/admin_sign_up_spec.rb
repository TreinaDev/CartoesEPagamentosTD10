require 'rails_helper'

describe 'Administrador faz login', type: :system do
  it 'com sucesso' do
    Admin.create!(
      name:
        'Maria Josefa Silva',
      cpf:
        '66681813330',
      email:
        'mjs@punti.com',
      password:
        '123456',
      password_confirmation:
        '123456'
    )

    visit root_path
    click_on 'Entrar'
    within('form') do
      fill_in 'E-mail', with: 'mjs@punti.com'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
    end

    expect(current_path).to eq root_path
    expect(page).to have_content 'Login efetuado com sucesso.'
    expect(page).to have_content 'Maria Josefa Silva'
    expect(page).to have_button 'Sair'
  end

  it 'e faz logout' do
    Admin.create!(
      name: 'Maria Josefa Silva',
      cpf: '88151478373',
      email: 'mariajs@punti.com',
      password: '123456',
      password_confirmation: '123456'
    )

    visit root_path
    click_on 'Entrar'
    within('form') do
      fill_in 'E-mail', with: 'mariajs@punti.com'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
    end
    within('#user-menu') do
      click_on 'Sair'
    end
    expect(page).to have_content 'Logout efetuado com sucesso.'
  end

  it 'e não tem acesso' do
    visit root_path
    click_on 'Entrar'
    within('form') do
      fill_in 'E-mail', with: 'edna@punti.com'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
    end

    expect(page).to have_content 'E-mail ou senha inválidos.'
  end
end
