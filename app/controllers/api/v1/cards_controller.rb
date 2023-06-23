class Api::V1::CardsController < Api::V1::ApiController
  def recharge
    return render status: :bad_request, json: { errors: t('.empty_request') } if params[:request].nil?

    recharge_transaction(params[:request])
  end

  def show
    card = Card.find_by(cpf: params[:id])
    if card.nil?
      render status: :not_found, json: { errors: 'Cartão não encontrado' }
    else
      render status: :ok, json: format_created_card(card)
    end
  end

  def create
    card_params = params.require(:card).permit(:cpf, :company_card_type_id)
    card = Card.new(card_params)

    if card.save
      render status: :created, json: format_created_card(card)
    else
      render status: :precondition_failed, json: { errors: card.errors.full_messages }
    end
  end

  def update
    card = Card.find(params[:id])
    if card.update(status: :inactive)
      render status: :ok, json: format_created_card(card)
    else
      render status: :precondition_failed, json: { errors: card.errors.full_messages }
    end
  end

  def block
    card = Card.find(params[:id])
    if card.update(status: :blocked)
      render status: :ok, json: format_created_card(card)
    else
      render status: :precondition_failed, json: { errors: card.errors.full_messages }
    end
  end

  private

  def recharge_transaction(request)
    Card.transaction do
      request.each do |r|
        card = Card.find_by(cpf: r[:cpf])
        raise ActiveRecord::RecordInvalid if card.blank?

        conversion = convert_to_points(card, r[:value])
        result = create_deposit(card, conversion) if card.update!(points: conversion + card.points)
      end
    end
    render status: :ok, json: { message: t('.recharge_successful') }
  rescue ActiveRecord::RecordInvalid
    render status: :bad_request, json: { errors: t('.recharge_failed') }
  end

  def convert_to_points(card, value)
    return unless value =~ /^[0-9]+(\.[0-9]{0,2})?$/

    card_conversion_tax = card.company_card_type.conversion_tax
    conversion = value.to_f - (value.to_f * (card_conversion_tax/100)).round
    conversion
  end

  def create_deposit(card, value)
    deposit = Deposit.create(amount: value, description: 'Recarga feita pela empresa', card:)
    Extract.create(date: deposit.created_at, operation_type: 'Depósito', value: deposit.amount,
                             description: "Recarga #{deposit.deposit_code}", card_number: card.number)
  end

  def format_created_card(card)
    {
      id: card.id,
      cpf: card.cpf,
      number: card.number,
      points: card.points,
      status: card.status,
      name: card.company_card_type.card_type.name
    }
  end
end
