class PaymentsController < ApplicationController
  def pending
    @pre_approved = Payment.pre_approved
    @pre_reproved = Payment.pre_rejected
  end

  def finished
    @finished_payments = Payment.where('status = 3 or status = 5')
  end

  def approve
    payment = Payment.find(params[:id])

    payment.approved!
    redirect_to pending_payments_path, notice: I18n.t('notices.payment_approved')
  end

  def reprove
    payment = Payment.find(params[:id])

    payment.rejected!
    ErrorsAssociation.create(payment_id: payment.id, error_message_id: 5)
    redirect_to pending_payments_path, notice: I18n.t('notices.payment_rejected')
  end
end
