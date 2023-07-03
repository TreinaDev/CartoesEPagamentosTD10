class PaymentsController < ApplicationController
  include QueryValidCashbackHelper
  include ReaisToPointsConversionHelper
  def pending
    @pre_approved = Payment.pre_approved
    @pre_reproved = Payment.pre_rejected
  end

  def finished
    @finished_payments = Payment.where('status = 3 or status = 5').order(updated_at: :desc)
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

  def search_pending
    search = params[:search]
    @pre_approved = Payment.where('(order_number LIKE ? OR cpf LIKE ?) AND (status = 2)', "%#{search}%",
                                  "%#{search}%")
    @pre_reproved = Payment.where('(order_number LIKE ? OR cpf LIKE ?) AND (status = 4)', "%#{search}%",
                                  "%#{search}%")
  end

  def search_ended
    search = params[:search]
    @finished_payments = Payment.where('(order_number LIKE ? OR cpf LIKE ?) AND (status = 3 OR status = 5)',
                                       "%#{search}%", "%#{search}%")
  end

  private

  def get_payment_card(payment)
    Card.find_by(number: payment.card_number)
  end
end
