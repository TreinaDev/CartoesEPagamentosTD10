class Api::V1::CardsController < Api::V1::ApiController
  def recharge
    messages = []
    return if params[:request].nil?

    params[:request].each do |r|
      card = Card.find_by(cpf: r[:cpf])
      messages << (!card.nil? && card.active? ? update_card(card, r) : { message: 'Cartão indisponível para recarga' })
    end
    render status: :ok, json: messages
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
      end
    end
  end
  
  def create_deposit(value)
    deposit = Deposit.create(amount: value, description: 'Recarga feita pela empresa')
    Extract.create(date: deposit.created_at, operation_type: 'Depósito', value: deposit.amount,
                   description: "Recarga #{deposit.deposit_code}")
  end

  def update_card(card, request)
    conversion = convert_to_points(card, request)
    if card.update(points: conversion)
      create_deposit(conversion)
      return { message: 'Recarga efetuada com sucesso' }
    end
    { message: 'Não foi possível concluir a recarga' }
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
