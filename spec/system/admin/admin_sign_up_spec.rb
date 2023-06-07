require 'rails_helper'

describe 'Admin do login', type: :system do
  it 'sucessfully' do
    # Arrange
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
    # Act
    visit root_path
    click_on 'Entrar'
    within('form') do
      fill_in 'E-mail', with: 'mjs@punti.com'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
    end
    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Login efetuado com sucesso.'
    expect(page).to have_content 'mjs@punti.com'
    expect(page).to have_button 'Sair'
  end

  it 'and do logout' do
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
    click_on 'Sair'
    # Assert
    expect(page).to have_content 'Logout efetuado com sucesso.'
  end

  it 'and can not access' do
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
