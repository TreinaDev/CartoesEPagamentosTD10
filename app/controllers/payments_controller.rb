class PaymentsController < ApplicationController
  include QueryValidCashbackHelper
  include ReaisToPointsConversionHelper
  def pending
    @pre_approved = Payment.pre_approved
    @pre_reproved = Payment.pre_rejected
  end

  def finished
    @finished_payments = Payment.where('status = 3 or status = 5')
  end

  def approve
    payment = Payment.find(params[:id])
    card = get_payment_card(payment)
    cashback = query_valid_cashback(payment.cpf)
    final_value = subtract_cashback_if_possible(card, payment, cashback)

    if can_approve_payment?(card, final_value)
      process_payment_approval(card, cashback, payment, final_value)
      return redirect_to pending_payments_path, notice: I18n.t('notices.payment_approved')
    end
    redirect_to pending_payments_path, alert: I18n.t('alerts.payment_approved_error')
  end

  def reprove
    payment = Payment.find(params[:id])

    payment.rejected!
    ErrorsAssociation.create(payment_id: payment.id, error_message_id: 5)
    redirect_to pending_payments_path, notice: I18n.t('notices.payment_rejected')
  end

  private

  def change_cashback_used(cashback)
    cashback.used = true
    cashback.save!
  end

  def create_cashback_if_possible(final_value, card, payment)
    return unless final_value >= card.company_card_type.cashback_rule.minimum_amount_points

    cashback_amount = (final_value * card.company_card_type.cashback_rule.cashback_percentage / 100).round
    cashback = Cashback.create!(amount: cashback_amount, payment:,
                                cashback_rule: card.company_card_type.cashback_rule, card:)
    generate_cashback_extract(cashback, payment, card)
  end

  def generate_cashback_extract(cashback, payment, card)
    venc = card.company_card_type.cashback_rule.days_to_use
    Extract.create(date: cashback.created_at, operation_type: 'crédito', value: cashback.amount,
                   description: "Cashback #{payment.order_number} Válido por #{venc} dia(s)", card_number: card.number)
  end

  def process_payment_approval(card, cashback, payment, final_value)
    change_cashback_used(cashback) if cashback.present?

    card.points -= final_value
    card.save!
    payment.approved!
    Extract.create(date: payment.payment_date, operation_type: 'débito', value: payment.final_value,
                   description: "Pedido #{payment.order_number}", card_number: card.number)
    return if card.company_card_type.cashback_rule.blank?

    create_cashback_if_possible(final_value, card, payment)
  end

  def can_approve_payment?(card, final_value)
    card.points >= final_value
  end

  def subtract_cashback_if_possible(card, payment, cashback)
    final_value = reais_to_points(card, payment.final_value)
    final_value -= cashback.amount if cashback.present?
    final_value
  end

  def get_payment_card(payment)
    Card.find_by(number: payment.card_number)
  end
end
