class CardTypesController < ApplicationController
  def index
    @card_types = CardType.all
    @cards_emission_enabled = CardType.enabled
    @cards_emission_disabled = CardType.disabled
  end

  def show
    @card_type = CardType.find(params[:id])
  end

  def new
    @card_type = CardType.new
  end

  def edit
    @card_type = CardType.find(params[:id])
  end

  def create
    @card_type = CardType.new(card_type_params)
    return redirect_to card_type_path(@card_type), notice: I18n.t('notices.card_type_created') if @card_type.save

    flash.now.alert = 'Não foi possível criar um novo tipo de cartão'
    render :new, status: :unprocessable_entity
  end

  def update
    @card_type = CardType.find(params[:id])
    return redirect_to @card_type, notice: I18n.t('notices.card_type_created') if @card_type.update(card_type_params)

    flash.now.alert = 'Não foi possível salvar as alterações'
    render :edit, status: :unprocessable_entity
  end

  def disable
    @card_type = CardType.find(params[:id])
    @card_type.emission = false
    @card_type.save!
    
    return redirect_to @card_type, notice: 'Emissão do cartão desabilitada com sucesso'
  end

  def enable
    @card_type = CardType.find(params[:id])
    @card_type.emission = true
    @card_type.save!
    
    return redirect_to @card_type, notice: 'Emissão do cartão habilitada com sucesso'
  end


  private

  def card_type_params
    params.require(:card_type).permit(:name, :icon, :start_points)
  end
end
