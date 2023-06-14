class CashbackRulesController < ApplicationController

  def index
    @cashback_rules = CashbackRule.all
  end

  def new
    @cashback_rule = CashbackRule.new
  end

  def create
    @cashback_rule = CashbackRule.new(cashback_rules_params)
    return redirect_to cashback_rules_path, notice: 'Regra de cashback criada com sucesso.' if @cashback_rule.save
    
    flash.now.alert = 'Não foi possível criar uma nova regra de cashback'
    render :new, status: :unprocessable_entity
  end

  def edit
    @cashback_rule = CashbackRule.find(params[:id])
  end

  def update
    @cashback_rule = CashbackRule.find(params[:id])

  end

  private

  def cashback_rules_params
    params.require(:cashback_rule).permit(:minimum_amount_points, :cashback_percentage, :days_to_use)
  end
end