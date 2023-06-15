class CashbackRulesController < ApplicationController
  def index
    @cashback_rules = CashbackRule.all
  end

  def new
    @cashback_rule = CashbackRule.new
  end

  def create
    @cashback_rule = CashbackRule.new(cashback_rules_params)
    return redirect_to cashback_rules_path, notice: I18n.t('notices.cashback_rule_created') if @cashback_rule.save

    flash.now.alert = I18n.t('alerts.failed_to_create_cashback_rule')
    render :new, status: :unprocessable_entity
  end

  private

  def cashback_rules_params
    params.require(:cashback_rule).permit(:minimum_amount_points, :cashback_percentage, :days_to_use)
  end
end
