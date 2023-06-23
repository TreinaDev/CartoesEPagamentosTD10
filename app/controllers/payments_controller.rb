class PaymentsController < ApplicationController
  def pending
    @pre_approved = Payment.pre_approved
    @pre_reproved = Payment.pre_rejected
  end

  def finished
    @finished_payments = Payment.where("status = 3 or status = 5")
  end

  def approve
    payment = Payment.find(params[:id])
    
    if payment.approved!
      return redirect_to pending_payments_path, notice: I18n.t('notices.payment_approved')
    end

    flash.now.alert = I18n.t('alerts.payment_approved_error')
    render :pending, status: :unprocessable_entity
  end

  def reprove
    payment = Payment.find(params[:id])
    
    if payment.rejected!
      ErrorsAssociation.create(payment: payment, error_message_id: 5) 
      return redirect_to pending_payments_path, notice: I18n.t('notices.payment_rejected')
    end

    flash.now.alert = I18n.t('alerts.payment_rejected_error')
    render :pending, status: :unprocessable_entity
  end
end