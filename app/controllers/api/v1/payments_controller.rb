class Api::V1::PaymentsController < Api::V1::ApiController
  def show
    payment = Payment.find_by!(code: params[:id])
    json_payment = format_created_payment(payment)
    render status: :ok, json: json_payment
  end

  def create
    payment_params = params.require(:payment).permit(:order_number, :total_value, :descount_amount, :final_value,
                                                     :cpf, :card_number, :payment_date)
    payment = Payment.new(payment_params)

    if payment.save
      render status: :created, json: format_created_payment(payment)
    else
      render status: :precondition_failed, json: { errors: payment.errors.full_messages }
    end
  end

  private

  def format_created_payment(payment)
    { order_number: payment.order_number,
      total_value: payment.total_value,
      descount_amount: payment.descount_amount,
      final_value: payment.final_value,
      cpf: payment.cpf,
      card_number: payment.card_number,
      payment_date: payment.payment_date,
      status: payment.status == 'pre_rejected' || payment.status == 'pre_approved' ? :pending : payment.status,
      code: payment.code }
  end
end
