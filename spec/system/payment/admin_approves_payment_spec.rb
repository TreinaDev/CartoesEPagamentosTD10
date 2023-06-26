require 'rails_helper'

describe 'Administrador entra na tela de pagamentos' do
  context 'e aprova' do
    it 'um pagamento pré aprovado com sucesso' do
      admin = FactoryBot.create(:admin)
      card = FactoryBot.create(:card)
      payment = FactoryBot.create(:payment, cpf: card.cpf, card_number: card.number, final_value: 5)

      login_as admin
      visit root_path
      within '#payment' do
        click_on 'Pendentes'
      end
      within "##{payment.order_number}" do
        click_on 'Aprovar pagamento'
      end

      expect(page).to have_content 'Pagamento aprovado com sucesso'
      within '#pre-approved-payments' do
        expect(page).to have_content 'Nenhum pagamento aguardando aprovação'
        expect(page).not_to have_content "Pedido #{payment.order_number}"
      end
    end

    it 'um pagamento sem modificar outro' do
      FactoryBot.create(:error_message, description: 'Cartão informado não existe')
      FactoryBot.create(:error_message, code: '002', description: 'Cartão não está ativo')
      FactoryBot.create(:error_message, code: '003', description: 'Cartão não pertence ao CPF informado')
      FactoryBot.create(:error_message, code: '004', description: 'Valor da compra é maior que o saldo do cartão')
      admin = FactoryBot.create(:admin)
      card = FactoryBot.create(:card, cpf: '22253043001')
      first_pay = FactoryBot.create(:payment, cpf: '22253043001', card_number: card.number, order_number: '1234567')
      second_pay = FactoryBot.create(:payment, cpf: '19261109004', card_number: card.number, order_number: '7845123')

      login_as admin
      visit root_path
      within '#payment' do
        click_on 'Pendentes'
      end
      within "##{first_pay.order_number}" do
        click_on 'Aprovar pagamento'
      end

      expect(page).to have_content 'Pagamento aprovado com sucesso'
      within '#pre-reproved-payments' do
        expect(page).to have_content "Pedido #{second_pay.order_number}"
        expect(page).to have_content 'Cartão não pertence ao CPF informado'
        expect(page).to have_button 'Reprovar pagamento'
      end

      within '#pre-approved-payments' do
        expect(page).to have_content 'Nenhum pagamento aguardando aprovação'
        expect(page).not_to have_content "Pedido #{first_pay.order_number}"
      end
    end
  end

  context 'e reprova' do
    it 'um pagamento pre aprovado com sucesso' do
      admin = FactoryBot.create(:admin)
      card = FactoryBot.create(:card)
      payment = FactoryBot.create(:payment, cpf: card.cpf, card_number: card.number, final_value: 5)

      login_as admin
      visit root_path
      within '#payment' do
        click_on 'Pendentes'
      end
      within "##{payment.order_number}" do
        click_on 'Reprovar pagamento'
      end

      expect(page).to have_content 'Pagamento reprovado com sucesso'
      within '#pre-approved-payments' do
        expect(page).to have_content 'Nenhum pagamento aguardando aprovação'
        expect(page).not_to have_content "Pedido #{payment.order_number}"
      end
    end

    it 'um pagamento pre reprovado com sucesso' do
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
      within "##{payment.order_number}" do
        click_on 'Reprovar pagamento'
      end

      expect(page).to have_content 'Pagamento reprovado com sucesso'
      within '#pre-reproved-payments' do
        expect(page).not_to have_content "Pedido #{payment.order_number}"
        expect(page).not_to have_content 'Cartão não pertence ao CPF informado'
        expect(page).not_to have_button 'Reprovar pagamento'
      end
    end

    it 'um pagamento sem modificar outro' do
      FactoryBot.create(:error_message, description: 'Cartão informado não existe')
      FactoryBot.create(:error_message, code: '002', description: 'Cartão não está ativo')
      FactoryBot.create(:error_message, code: '003', description: 'Cartão não pertence ao CPF informado')
      FactoryBot.create(:error_message, code: '004', description: 'Valor da compra é maior que o saldo do cartão')
      admin = FactoryBot.create(:admin)
      card = FactoryBot.create(:card, cpf: '22253043001')
      first_pay = FactoryBot.create(:payment, cpf: '22253043001', card_number: card.number, order_number: '1234567')
      second_pay = FactoryBot.create(:payment, cpf: '19261109004', card_number: card.number, order_number: '7845123')

      login_as admin
      visit root_path
      within '#payment' do
        click_on 'Pendentes'
      end
      within "##{second_pay.order_number}" do
        click_on 'Reprovar pagamento'
      end

      expect(page).to have_content 'Pagamento reprovado com sucesso'
      within '#pre-reproved-payments' do
        expect(page).to have_content 'Nenhum pagamento aguardando reprovação'
        expect(page).not_to have_content "Pedido #{second_pay.order_number}"
        expect(page).not_to have_content 'Cartão não pertence ao CPF informado'
        expect(page).not_to have_button 'Reprovar pagamento'
      end
      within '#pre-approved-payments' do
        expect(page).to have_content "Pedido #{first_pay.order_number}"
        expect(page).to have_content "Número do cartão\n#{first_pay.card_number}"
        expect(page).to have_content "CPF do cliente\n#{first_pay.format_cpf(first_pay.cpf)}"
        expect(page).to have_content "Valor total\nR$ #{first_pay.format_money(first_pay.total_value)}"
        expect(page).to have_content "Valor do desconto\nR$ #{first_pay.format_money(first_pay.descount_amount)}"
        expect(page).to have_content "Valor final\nR$ #{first_pay.format_money(first_pay.final_value)}"
        expect(page).to have_content "Saldo atual\n#{first_pay.check_balance(first_pay.card_number)} pontos"
        expect(page).to have_content "Saldo após a compra\n#{first_pay.get_final_balance(first_pay)} pontos"
        expect(page).to have_button 'Aprovar pagamento'
        expect(page).to have_button 'Reprovar pagamento'
      end
    end
  end
end
