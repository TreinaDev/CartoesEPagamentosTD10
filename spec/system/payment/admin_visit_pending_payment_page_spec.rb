require 'rails_helper'

describe 'Administrador entra na tela de pagamentos pendentes' do
  it 'mas não está logado' do
    visit pending_payments_path

    expect(current_path).to eq '/admins/sign_in'
    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end

  context 'e vê' do
    it 'que nenhum pagamento está aguardando aprovação' do
      admin = FactoryBot.create(:admin)

      login_as admin
      visit root_path
      within '#payment' do
        click_on 'Pendentes'
      end

      within '#pre-approved-payments' do
        expect(page).to have_content 'Nenhum pagamento aguardando aprovação'
      end
      within '#pre-reproved-payments' do
        expect(page).to have_content 'Nenhum pagamento aguardando reprovação'
      end
    end

    it 'pagamento pre-aprovado aguardando finalização' do
      admin = FactoryBot.create(:admin)
      card = FactoryBot.create(:card)
      payment = FactoryBot.create(:payment, cpf: card.cpf, card_number: card.number, final_value: 5)

      login_as admin
      visit root_path
      within '#payment' do
        click_on 'Pendentes'
      end

      within '#pre-approved-payments' do
        expect(page).to have_content "Pedido #{payment.order_number}"
        expect(page).to have_content "Número do cartão\n#{payment.card_number}"
        expect(page).to have_content "CPF do cliente\n#{payment.format_cpf(payment.cpf)}"
        expect(page).to have_content "Valor total\nR$ #{payment.format_money(payment.total_value)}"
        expect(page).to have_content "Valor do desconto\nR$ #{payment.format_money(payment.descount_amount)}"
        expect(page).to have_content "Valor final\nR$ #{payment.format_money(payment.final_value)}"
        expect(page).to have_content "Saldo atual\n#{payment.check_balance(payment.card_number)} pontos"
        expect(page).to have_content "Saldo após a compra\n#{payment.get_final_balance(payment)} pontos"
        expect(page).to have_button 'Aprovar pagamento'
        expect(page).to have_button 'Reprovar pagamento'
      end
    end

    it 'pagamento pre-reprovado aguardando finalização' do
      FactoryBot.create(:error_message, description: 'Cartão informado não existe')
      FactoryBot.create(:error_message, code: '002', description: 'Cartão não está ativo')
      FactoryBot.create(:error_message, code: '003', description: 'Cartão não pertence ao CPF informado')
      FactoryBot.create(:error_message, code: '004', description: 'Valor da compra é maior que o saldo do cartão')
      admin = FactoryBot.create(:admin)
      card = FactoryBot.create(:card, cpf: '22253043001')
      payment = FactoryBot.create(:payment, cpf: '19261109004', card_number: card.number)

      login_as admin
      visit root_path
      within '#payment' do
        click_on 'Pendentes'
      end

      within '#pre-reproved-payments' do
        expect(page).to have_content "Pedido #{payment.order_number}"
        expect(page).to have_content 'Cartão não pertence ao CPF informado'
        expect(page).to have_button 'Reprovar pagamento'
        expect(page).not_to have_button 'Aprovar pagamento'
      end
    end
  end
end
