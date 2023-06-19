class Api::V1::CardsController < Api::V1::ApiController
  before_action :set_new_card, only: %i[create upgrade]

  def show
    card = Card.find_by(cpf: params[:id])
    if card.nil?
      render status: :not_found, json: { errors: 'Cartão não encontrado' }
    else
      render status: :ok, json: format_created_card(card)
    end
  end

  def create
    if @card.save
      render status: :created, json: format_created_card(@card)
    else
      render status: :precondition_failed, json: { errors: @card.errors.full_messages }
    end
  end

  def deactivate
    card = Card.find(params[:id])
    if card.update(status: :inactive)
      render status: :ok, json: format_created_card(card)
    else
      render status: :precondition_failed, json: { errors: card.errors.full_messages }
    end
  end

  def activate
    card = Card.find(params[:id])
    if card.update(status: :active)
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

  def upgrade
    old_card = Card.find_by!(cpf: @card_params[:cpf], status: :active)
    return render status: :precondition_failed, json: { errors: 'Mesmo tipo de cartão' } if check_type(old_card, @card)

    if @card.company_card_type && old_card.company_card_type.cnpj != @card.company_card_type.cnpj
      return render status: :precondition_failed,
                    json: { errors: 'CNPJ do tipo de cartão diferente do cartão anterior' }
    end

    update_transaction(old_card, @card)
  end

  private

  def set_new_card
    @card_params = params.require(:card).permit(:cpf, :company_card_type_id)
    @card = Card.new(@card_params)
  end

  def check_type(old_card, card)
    old_card.company_card_type_id == card.company_card_type_id
  end

  def update_transaction(old_card, card)
    Card.transaction do
      old_card.update!(status: :blocked)
      card.save!
    end
    render status: :ok, json: format_created_card(card)
  rescue ActiveRecord::RecordInvalid
    render status: :precondition_failed, json: { errors: card.errors.full_messages }
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
