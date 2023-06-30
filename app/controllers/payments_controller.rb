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
    final_value = payment.subtract_cashback_if_possible(card, cashback)

    if card.can_approve_payment?(final_value) && payment.process_payment_approval(card, cashback, final_value)
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

  def get_payment_card(payment)
    Card.find_by(number: payment.card_number)
  end
end
