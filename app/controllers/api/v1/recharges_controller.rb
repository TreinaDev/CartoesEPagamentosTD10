class Api::V1::RechargesController < Api::V1::ApiController
  include ReaisToPointsConversionHelper

  def update
    request = params.require(:recharge)
    messages = []
    request.each do |r|
      card = Card.find_by(cpf: r[:cpf])
      messages << (!card.nil? && card.active? ? update_card(card, r) : { cpf: r[:cpf], errors: t('.unsucessful_recharge') })
    end
    render status: :ok, json: messages
  end

  private

  def convert_to_points(card, value)
    return unless value =~ /^[0-9]+(\.[0-9]{0,2})?$/

    reais_to_points(card, value)
  end

  def create_deposit(card, points)
    deposit = Deposit.create(amount: points, description: 'Recarga feita pela empresa', card:)
    Extract.create(date: deposit.created_at, operation_type: 'Depósito', value: deposit.amount,
                   description: "Recarga #{deposit.deposit_code}", card_number: card.number)
  end

  def update_card(card, request)
    card = Card.find_by(cpf: card[:cpf])
    recharge_points = convert_to_points(card, request[:value])
    
    if card.update(points: card.points + recharge_points)
      create_deposit(card, recharge_points)
      return { cpf: card.cpf, message: t('.sucessful_recharge') }
    end

    { cpf: card.cpf, errors: t('.unsucessful_recharge') }
  end
end
