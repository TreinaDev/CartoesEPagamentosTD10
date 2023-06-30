require 'rails_helper'

describe 'Administrador busca por um pagamento pendente' do
  it 'a partir do página de pagamentos pendentes' do
    admin = FactoryBot.create(:admin)

    login_as admin
    visit root_path
    within '#payment' do
      click_on 'Pendentes'
    end

    expect(page).to have_css 'input.search-field'
    expect(page).to have_css 'button.search-btn'
  end

  it 'e encontra um pagamento pendente pré aprovado pelo número do pedido' do
    admin = FactoryBot.create(:admin)
    card = FactoryBot.create(:card)
    payment = FactoryBot.create(:payment, cpf: card.cpf, card_number: card.number, final_value: 5)
    other_payment = FactoryBot.create(:payment, order_number: '654321', cpf: card.cpf, card_number: card.number,
                                                final_value: 5)

    login_as admin
    visit root_path
    within '#payment' do
      click_on 'Pendentes'
    end
    input = find('input.search-field')
    input.set(payment.order_number)
    button = find('button.search-btn')
    button.click

    expect(page).to have_content "Pedido #{payment.order_number}"
    expect(page).not_to have_content "Pedido #{other_payment.order_number}"
  end

  it 'e encontra um pagamento pendente pré reprovado pelo número do pedido' do
    admin = FactoryBot.create(:admin)
    card = FactoryBot.create(:card)
    payment = FactoryBot.create(:payment, cpf: card.cpf, card_number: card.number)
    other_payment = FactoryBot.create(:payment, order_number: '654321', cpf: card.cpf, card_number: card.number)

    login_as admin
    visit root_path
    within '#payment' do
      click_on 'Pendentes'
    end
    input = find('input.search-field')
    input.set(payment.order_number)
    find('button.search-btn').click

    expect(page).to have_content "Pedido #{payment.order_number}"
    expect(page).not_to have_content "Pedido #{other_payment.order_number}"
  end

  it 'e encontra um pagamento pendente pré aprovado pelo CPF do comprador' do
    admin = FactoryBot.create(:admin)
    FactoryBot.create(:company_card_type)
    card = FactoryBot.create(:card, company_card_type_id: 1)
    other_card = FactoryBot.create(:card, cpf: '51147219095', company_card_type_id: 1)
    payment = FactoryBot.create(:payment, cpf: card.cpf, card_number: card.number, final_value: 5)
    other_payment = FactoryBot.create(:payment, order_number: '654321', cpf: other_card.cpf,
                                                card_number: other_card.number, final_value: 5)

    login_as admin
    visit root_path
    within '#payment' do
      click_on 'Pendentes'
    end
    input = find('input.search-field')
    input.set(payment.cpf)
    find('button.search-btn').click

    expect(page).to have_content "Pedido #{payment.order_number}"
    expect(page).not_to have_content "Pedido #{other_payment.order_number}"
  end

  it 'e encontra um pagamento pendente pré reprovado pelo CPF do comprador' do
    admin = FactoryBot.create(:admin)
    FactoryBot.create(:company_card_type)
    card = FactoryBot.create(:card, company_card_type_id: 1)
    other_card = FactoryBot.create(:card, cpf: '51147219095', company_card_type_id: 1)
    payment = FactoryBot.create(:payment, cpf: card.cpf, card_number: card.number)
    other_payment = FactoryBot.create(:payment, order_number: '654321', cpf: other_card.cpf,
                                                card_number: other_card.number)

    login_as admin
    visit root_path
    within '#payment' do
      click_on 'Pendentes'
    end
    input = find('input.search-field')
    input.set(payment.cpf)
    find('button.search-btn').click

    expect(page).to have_content "Pedido #{payment.order_number}"
    expect(page).not_to have_content "Pedido #{other_payment.order_number}"
  end

  it 'e encontra múltiplos pagamentos pendentes' do
    admin = FactoryBot.create(:admin)
    card = FactoryBot.create(:card)
    payment = FactoryBot.create(:payment, cpf: card.cpf, card_number: card.number, final_value: 5)
    other_payment = FactoryBot.create(:payment, order_number: '654321', cpf: card.cpf, card_number: card.number)

    login_as admin
    visit root_path
    within '#payment' do
      click_on 'Pendentes'
    end
    input = find('input.search-field')
    input.set(payment.cpf)
    find('button.search-btn').click

    expect(page).to have_content "Pedido #{payment.order_number}"
    expect(page).to have_content "Pedido #{other_payment.order_number}"
  end
end
