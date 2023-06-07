class CardTypesController < ApplicationController
  def index
    @card_types = CardType.all
  end

  def new
    @card_type = CardType.new
  end

  def create
    @card_type = CardType.new(card_type_params)
    if @card_type.valid?
      @card_type.save!
      return redirect_to card_type_path(@card_type), notice: 'Novo tipo de cartão criado com sucesso'
    end
    flash.now.alert = 'Não foi possível criar um novo tipo de cartão'
    render :new, status: 422
  end

  def show
    @card_type = CardType.find(params[:id])
  end

  def edit
    @card_type = CardType.find(params[:id])
  end

  def update 
    @card_type = CardType.find(params[:id])
    if @card_type.update(card_type_params)
      return redirect_to @card_type, notice: 'Tipo de cartão atualizado com sucesso'
    end
    flash.now[:alert] = 'Não foi possível salvar as alterações'
    render :edit, status: 422
  end

  private 

  def card_type_params
    params.require(:card_type).permit(:name, :icon, :start_points)
  end
end