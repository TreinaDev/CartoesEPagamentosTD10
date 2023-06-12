class CardsController < ApplicationController
  before_action :authenticate_admin!
  def index
    @cards = Card.all
  end

  def show
    @card = Card.find(params[:id])
  end

  private

  def card_params
    params.require(:card).permit(:number, :cpf, :points, :status, :card_type_id)
  end
end
