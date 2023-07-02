require 'rails_helper'

describe 'Administrador entra na tela de pagamentos' do
  context 'e aprova' do
    describe 'um pagamento pré aprovado' do
      it 'sem usar cashback pois não existe nenhum' do
        admin = FactoryBot.create(:admin)
        card = FactoryBot.create(:card, points: 1500)
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

      it 'usando cashback com sucesso' do
        admin = FactoryBot.create(:admin)
        cashback_rule = FactoryBot.create(:cashback_rule, days_to_use: 10, cashback_percentage: 3,
                                                          minimum_amount_points: 50)
        company_card_type = FactoryBot.create(:company_card_type, cashback_rule:, conversion_tax: 20.5)
        card = FactoryBot.create(:card, company_card_type:, points: 1500)

        other_payment = FactoryBot.create(:payment, order_number: 465_452, cpf: card.cpf, card_number: card.number,
                                                    final_value: 100)
        FactoryBot.create(:cashback, amount: 5, payment: other_payment, card:, cashback_rule:)
        payment = FactoryBot.create(:payment, cpf: card.cpf, card_number: card.number, final_value: 50)

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

        expect(Cashback.first.used).to eq(true)
        expect(Card.first.points).to eq(480)
      end

      it 'sem usar cashback pois o cashback que existia já expirou' do
        admin = FactoryBot.create(:admin)
        cashback_rule = FactoryBot.create(:cashback_rule, days_to_use: 10, cashback_percentage: 3,
                                                          minimum_amount_points: 50)
        company_card_type = FactoryBot.create(:company_card_type, cashback_rule:, conversion_tax: 20.5)
        card = FactoryBot.create(:card, company_card_type:, points: 1500)

        other_payment = FactoryBot.create(:payment, order_number: 465_452, cpf: card.cpf, card_number: card.number,
                                                    final_value: 100)
        FactoryBot.create(:cashback, amount: 5, payment: other_payment, card:, cashback_rule:, created_at: 11.days.ago)
        payment = FactoryBot.create(:payment, cpf: card.cpf, card_number: card.number, final_value: 50)

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
        expect(Cashback.first.used).to eq(false)
        expect(Card.first.points).to eq(475)
      end

      it 'e tenta aprovar outro, porém falha pois não há saldo suficiente no cartão' do
        admin = FactoryBot.create(:admin)
        cashback_rule = FactoryBot.create(:cashback_rule, days_to_use: 10, cashback_percentage: 3,
                                                          minimum_amount_points: 50)
        company_card_type = FactoryBot.create(:company_card_type, cashback_rule:, conversion_tax: 20.5)
        card = FactoryBot.create(:card, company_card_type:, points: 1500)

        other_payment = FactoryBot.create(:payment, order_number: 465_452, cpf: card.cpf, card_number: card.number,
                                                    final_value: 50)
        payment = FactoryBot.create(:payment, cpf: card.cpf, card_number: card.number, final_value: 50)

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
          expect(page).not_to have_content "Pedido #{payment.order_number}"
        end
        within "##{other_payment.order_number}" do
          click_on 'Aprovar pagamento'
        end
        expect(page).to have_content 'Não foi possível aprovar o pagamento'
        expect(other_payment.status).to eq('pre_approved')
      end

      it 'e tenta aprovar, porém houve erro durante a transação' do
        admin = FactoryBot.create(:admin)
        cashback_rule = FactoryBot.create(:cashback_rule, days_to_use: 10, cashback_percentage: 3,
                                                          minimum_amount_points: 50)
        company_card_type = FactoryBot.create(:company_card_type, cashback_rule:, conversion_tax: 20.5)
        card = FactoryBot.create(:card, company_card_type:, points: 1500)
        payment = FactoryBot.create(:payment, cpf: card.cpf, card_number: card.number, final_value: 50)
        allow(Extract).to receive(:create).and_raise(ActiveRecord::RecordInvalid)

        login_as admin
        visit root_path
        within '#payment' do
          click_on 'Pendentes'
        end
        within "##{payment.order_number}" do
          click_on 'Aprovar pagamento'
        end

        expect(page).to have_content 'Não foi possível aprovar o pagamento'
      end

      it 'e gera um cashback corretamente' do
        admin = FactoryBot.create(:admin)
        cashback_rule = FactoryBot.create(:cashback_rule, days_to_use: 10, cashback_percentage: 3,
                                                          minimum_amount_points: 50)
        company_card_type = FactoryBot.create(:company_card_type, cashback_rule:, conversion_tax: 20.5)
        card = FactoryBot.create(:card, company_card_type:, points: 1500)
        payment = FactoryBot.create(:payment, cpf: card.cpf, card_number: card.number, final_value: 50)

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

        expect(Cashback.all.first.amount).to eq(31)
      end

      it 'e não gera um cashback pois o valor em pontos da compra não satisfaz o mínimo' do
        admin = FactoryBot.create(:admin)
        cashback_rule = FactoryBot.create(:cashback_rule, days_to_use: 10, cashback_percentage: 3,
                                                          minimum_amount_points: 500)
        company_card_type = FactoryBot.create(:company_card_type, cashback_rule:, conversion_tax: 20.5)
        card = FactoryBot.create(:card, company_card_type:)
        payment = FactoryBot.create(:payment, cpf: card.cpf, card_number: card.number, final_value: 10)

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

        expect(Cashback.count).to eq(0)
      end

      it 'um pagamento sem modificar outro' do
        FactoryBot.create(:error_message, description: 'Cartão informado não existe')
        FactoryBot.create(:error_message, code: '002', description: 'Cartão não está ativo')
        FactoryBot.create(:error_message, code: '003', description: 'Cartão não pertence ao CPF informado')
        FactoryBot.create(:error_message, code: '004', description: 'Valor da compra é maior que o saldo do cartão')
        admin = FactoryBot.create(:admin)
        card = FactoryBot.create(:card, cpf: '22253043001', points: 1500)
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

      it 'e gera um extrato de pagamento' do
        admin = FactoryBot.create(:admin)
        card = FactoryBot.create(:card, points: 1500)
        payment = FactoryBot.create(:payment, cpf: card.cpf, card_number: card.number, final_value: 5)

        login_as admin
        visit root_path
        within '#payment' do
          click_on 'Pendentes'
        end
        within "##{payment.order_number}" do
          click_on 'Aprovar pagamento'
        end

        extract = Extract.first
        expect(Extract.all.length).to eq 1
        expect(extract.date).to eq payment.payment_date
        expect(extract.value).to eq 50
        expect(extract.card_number).to eq card.number
        expect(extract.description).to eq "Pedido #{payment.order_number}"
        expect(extract.operation_type).to eq 'débito'
      end

      it 'e gera um extrato de cashback' do
        admin = FactoryBot.create(:admin)
        cashback_rule = FactoryBot.create(:cashback_rule, cashback_percentage: 3, days_to_use: 10,
                                                          minimum_amount_points: 500)
        company_card_type = FactoryBot.create(:company_card_type, cashback_rule:, conversion_tax: 20)
        card = FactoryBot.create(:card, company_card_type:)
        card.update!(points: 2000)
        payment = FactoryBot.create(:payment, cpf: card.cpf, card_number: card.number, final_value: 100)

        login_as admin
        visit root_path
        within '#payment' do
          click_on 'Pendentes'
        end
        within "##{payment.order_number}" do
          click_on 'Aprovar pagamento'
        end

        extract = Extract.last
        cashback = Cashback.first
        venc = card.company_card_type.cashback_rule.days_to_use
        expect(Extract.all.length).to eq 2
        expect(extract.date).to eq cashback.created_at
        expect(extract.value).to eq 60
        expect(extract.card_number).to eq card.number
        expect(extract.description).to eq "Cashback #{payment.order_number} Válido por #{venc} dia(s)"
        expect(extract.operation_type).to eq 'crédito'
      end
    end
  end

  context 'e reprova' do
    it 'um pagamento pre aprovado com sucesso' do
      admin = FactoryBot.create(:admin)
      card = FactoryBot.create(:card, points: 1500)
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
      card = FactoryBot.create(:card, cpf: '22253043001', points: 1500)
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
      card = FactoryBot.create(:card, cpf: '22253043001', points: 1500)
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
        expect(page).to have_content "Número do cartão #{first_pay.formatted_card_number}"
        expect(page).to have_content "CPF do cliente #{first_pay.format_cpf(first_pay.cpf)}"
        expect(page).to have_content "Valor total R$ #{first_pay.format_money(first_pay.total_value)}"
        expect(page).to have_content "Valor do desconto R$ #{first_pay.format_money(first_pay.descount_amount)}"
        expect(page).to have_content "Valor final R$ #{first_pay.format_money(first_pay.final_value)}"
        expect(page).to have_content "Saldo atual #{first_pay.check_balance(first_pay.card_number)} pontos"
        expect(page).to have_content "Saldo após a compra #{first_pay.get_final_balance(first_pay)} pontos"
        expect(page).to have_button 'Aprovar pagamento'
        expect(page).to have_button 'Reprovar pagamento'
      end
    end
  end
end
