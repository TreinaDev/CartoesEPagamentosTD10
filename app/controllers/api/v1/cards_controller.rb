class Api::V1::CardsController < Api::V1::ApiController
  before_action :prepare_new_card, only: %i[create upgrade]

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

  def upgrade
    old_card = Card.find_by!(cpf: @card_params[:cpf], status: :active)
    Card.transaction do
      old_card.update!(status: :blocked)
      @card.save!
    end
    render status: :ok, json: format_created_card(@card)
  rescue ActiveRecord::RecordInvalid
    render status: :precondition_failed, json: { errors: @card.errors.full_messages }
  end

  private

  def prepare_new_card
    @card_params = params.require(:card).permit(:cpf, :company_card_type_id)
    @card = Card.new(@card_params)
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
