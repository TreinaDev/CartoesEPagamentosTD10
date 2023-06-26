class Api::V1::RechargesController < Api::V1::ApiController
  include ReaisToPointsConversionHelper

  def update
    request = params.require(:recharge)
    messages = []
    request.each do |r|
      card = Card.find_by(cpf: r[:cpf])
      messages << (
        !card.nil? && card.active? ? update_card(card, r) : { cpf: r[:cpf], errors: t('.inactive_card_or_not_found') }
      )
    end
    render status: :ok, json: messages
  end

  private

  def convert_to_points(card, value)
    return unless value.to_s =~ /^[0-9]+(\.[0-9]{0,2})?$/

    reais_to_points(card, value.to_f)
  end

  def create_deposit(card, points)
    deposit = Deposit.create(amount: points, description: 'Recarga feita pela empresa', card:)
    Extract.create(date: deposit.created_at, operation_type: 'Depósito', value: deposit.amount,
                   description: "Recarga #{deposit.deposit_code}", card_number: card.number)
  end

  def update_card(card, request)
    card = Card.find_by(cpf: card[:cpf])
    recharge_points = convert_to_points(card, request[:value])

    return { cpf: card.cpf, errors: t('.check_your_value') } if recharge_points.nil?

    if card.update(points: card.points + recharge_points)
      { cpf: card.cpf, message: t('.successful_recharge') } if create_deposit(card, recharge_points)
    else
      { cpf: card.cpf, errors: t('.unsuccessful_recharge') }
    end
  end
end
