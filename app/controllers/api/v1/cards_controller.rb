class Api::V1::CardsController < Api::V1::ApiController
  def create
    card_params = params.require(:card).permit(:cpf, :company_card_type_id)
    card = Card.new(card_params)

    if card.save
      render status: :created, json: format_created_card(card)
    else
      render status: :precondition_failed, json: { errors: card.errors.full_messages }
    end
  end

  def destroy
    card = Card.find(params[:id])
    card.update!(status: :inactive)
    render status: :ok, json: format_created_card(card)
  end

  private

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
