require 'rails_helper'

describe 'Administrador acessa a home page' do
  it 'e visualiza uma saudação' do
    admin = FactoryBot.create(:admin, name: 'Maria Silva')

    login_as admin
    visit root_path

    expect(page).to have_content 'Olá, Maria Silva'
  end

  it 'e acessa a tela de novo tipo de cartão' do
    admin = FactoryBot.create(:admin)

    login_as admin
    visit root_path
    within('#card-menu') do
      click_on 'Novo tipo de cartão'
    end

    expect(current_path).to eq new_card_type_path
  end

  it 'e acessa a tela de tipos de cartão' do
    admin = FactoryBot.create(:admin)

    login_as admin
    visit root_path
    within('#card-menu') do
      click_on 'Tipos de cartões'
    end

    expect(current_path).to eq card_types_path
  end

  it 'e acessa a tela de Disponibilizar tipos de cartões' do
    admin = FactoryBot.create(:admin)
    companies = []
    allow(Company).to receive(:all).and_return(companies)

    login_as admin
    visit root_path
    within('#card-menu') do
      click_on 'Disponibilizar tipos de cartões'
    end

    expect(current_path).to eq companies_path
  end

  it 'e acessa a tela de Nova regra de cashback' do
    admin = FactoryBot.create(:admin)

    login_as admin
    visit root_path
    within('#cashback-menu') do
      click_on 'Nova regra de cashback'
    end

    expect(current_path).to eq new_cashback_rule_path
  end

  it 'e acessa a tela de Regras de cashback' do
    admin = FactoryBot.create(:admin)

    login_as admin
    visit root_path

    within('#cashback-menu') do
      click_on 'Regras de cashback'
    end

    expect(current_path).to eq cashback_rules_path
  end

  it 'e acessa a tela de Pendente' do
    admin = FactoryBot.create(:admin)

    login_as admin
    visit root_path
    within('#payments-menu') do
      click_on 'Pendente'
    end

    expect(current_path).to eq pending_payments_path
  end

  it 'e acessa a tela de Finalizado' do
    admin = FactoryBot.create(:admin)

    login_as admin
    visit root_path
    within('#payments-menu') do
      click_on 'Finalizado'
    end

    expect(current_path).to eq finished_payments_path
  end
end
