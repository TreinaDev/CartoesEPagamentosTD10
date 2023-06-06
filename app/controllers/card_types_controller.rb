class CardTypesController < ApplicationController
  def new
    @card_type = CardType.new
  end

  def create
    @card_type = CardType.new(card_type_params)
    if @card_type.valid?
      @card_type.save!
      return redirect_to card_type_path(@card_type), notice: 'Novo tipo de cartão criado com sucesso'
    end
    render :new, status: 422
  end

  def show
    @card_type = CardType.find(params[:id])
  end

  private 

  def card_type_params
    params.require(:card_type).permit(:name, :icon, :start_points)
  end
end