require 'rails_helper'

describe 'Administrador busca por um pagamento finalizado' do
  it 'a partir do página de pagamentos finalizados' do
    admin = FactoryBot.create(:admin)

    login_as admin
    visit root_path
    within '#payment' do
      click_on 'Finalizados'
    end

    expect(page).to have_css 'input.search-field'
    expect(page).to have_css 'button.search-btn'
  end

  it 'e encontra um pagamento aprovado pelo número do pedido' do
    admin = FactoryBot.create(:admin)
    card = FactoryBot.create(:card)
    payment = FactoryBot.create(:payment, cpf: card.cpf, card_number: card.number, final_value: 5)
    other_payment = FactoryBot.create(:payment, order_number: '654321', cpf: card.cpf, card_number: card.number,
                                                final_value: 5)
    payment.approved!
    other_payment.approved!

    login_as admin
    visit root_path
    within '#payment' do
      click_on 'Finalizados'
    end
    input = find('input.search-field')
    input.set(payment.order_number)
    find('button.search-btn').click

    expect(page).to have_content "Pedido #{payment.order_number}"
    expect(page).not_to have_content "Pedido #{other_payment.order_number}"
  end

  it 'e encontra um pagamento reprovado pelo número do pedido' do
    admin = FactoryBot.create(:admin)
    card = FactoryBot.create(:card)
    payment = FactoryBot.create(:payment, cpf: card.cpf, card_number: card.number)
    other_payment = FactoryBot.create(:payment, order_number: '654321', cpf: card.cpf, card_number: card.number)
    payment.rejected!
    other_payment.rejected!

    login_as admin
    visit root_path
    within '#payment' do
      click_on 'Finalizados'
    end
    input = find('input.search-field')
    input.set(payment.order_number)
    find('button.search-btn').click

    expect(page).to have_content "Pedido #{payment.order_number}"
    expect(page).not_to have_content "Pedido #{other_payment.order_number}"
  end

  it 'e encontra um pagamento aprovado pelo CPF do comprador' do
    admin = FactoryBot.create(:admin)
    FactoryBot.create(:company_card_type)
    card = FactoryBot.create(:card, company_card_type_id: 1)
    other_card = FactoryBot.create(:card, cpf: '51147219095', company_card_type_id: 1)
    payment = FactoryBot.create(:payment, cpf: card.cpf, card_number: card.number, final_value: 5)
    other_payment = FactoryBot.create(:payment, order_number: '654321', cpf: other_card.cpf,
                                                card_number: other_card.number, final_value: 5)
    payment.approved!
    other_payment.approved!

    login_as admin
    visit root_path
    within '#payment' do
      click_on 'Finalizados'
    end
    input = find('input.search-field')
    input.set(payment.cpf)
    find('button.search-btn').click

    expect(page).to have_content "Pedido #{payment.order_number}"
    expect(page).not_to have_content "Pedido #{other_payment.order_number}"
  end

  it 'e encontra um pagamento reprovado pelo CPF do comprador' do
    admin = FactoryBot.create(:admin)
    FactoryBot.create(:company_card_type)
    card = FactoryBot.create(:card, company_card_type_id: 1)
    other_card = FactoryBot.create(:card, cpf: '51147219095', company_card_type_id: 1)
    payment = FactoryBot.create(:payment, cpf: card.cpf, card_number: card.number)
    other_payment = FactoryBot.create(:payment, order_number: '654321', cpf: other_card.cpf,
                                                card_number: other_card.number)
    payment.rejected!
    other_payment.rejected!

    login_as admin
    visit root_path
    within '#payment' do
      click_on 'Finalizados'
    end
    input = find('input.search-field')
    input.set(payment.cpf)
    find('button.search-btn').click

    expect(page).to have_content "Pedido #{payment.order_number}"
    expect(page).not_to have_content "Pedido #{other_payment.order_number}"
  end

  it 'e encontra múltiplos pagamentos finalizados' do
    admin = FactoryBot.create(:admin)
    card = FactoryBot.create(:card)
    payment = FactoryBot.create(:payment, cpf: card.cpf, card_number: card.number, final_value: 5)
    other_payment = FactoryBot.create(:payment, order_number: '654321', cpf: card.cpf, card_number: card.number)
    payment.approved!
    other_payment.rejected!

    login_as admin
    visit root_path
    within '#payment' do
      click_on 'Finalizados'
    end
    input = find('input.search-field')
    input.set(payment.cpf)
    find('button.search-btn').click

    expect(page).to have_content "Pedido #{payment.order_number}"
    expect(page).to have_content "Pedido #{other_payment.order_number}"
  end
end
