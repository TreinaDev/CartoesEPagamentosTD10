class Api::V1::PaymentsController < Api::V1::ApiController
  def index
    payment = Payment.find_by!(code: params[:code])

    json_payment = format_created_payment(payment)
    render status: :ok, json: json_payment
  end

  private

  def format_created_payment(payment)
    { order_number: payment.order_number,
      total_value: payment.total_value,
      descount_amount: payment.descount_amount,
      final_value: payment.final_value,
      cpf: payment.cpf,
      card_number: payment.card_number,
      status: payment.status,
      code: payment.code }
  end
end
