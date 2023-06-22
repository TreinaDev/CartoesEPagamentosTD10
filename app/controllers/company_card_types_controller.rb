class CompanyCardTypesController < ApplicationController
  before_action :set_company_card_type, only: %i[update enable disable]

  def create
    company_card_type = CompanyCardType.new(company_card_type_params)

    if company_card_type.save
      redirect_to company_path(params[:company_id]), notice: I18n.t('.notices.company_card_type_created')
    else
      redirect_to company_path(params[:company_id]), notice: I18n.t('.notices.company_card_type_creation_failed')
    end
  end

  def update
    return unless @company_card_type.update(company_card_type_params)

    redirect_to company_path(params[:company_id]), notice: I18n.t('.notices.company_card_type_updated')
  end

  def enable
    @company_card_type.active!

    redirect_to company_path(params[:company_id]), notice: I18n.t('.notices.company_card_type_enabled')
  end

  def disable
    @company_card_type.inactive!

    redirect_to company_path(params[:company_id]), notice: I18n.t('.notices.company_card_type_disabled')
  end

  private

  def company_card_type_params
    params.require(:company_card_type).permit(:cnpj, :card_type_id, :cashback_rule_id, :conversion_tax)
  end

  def set_company_card_type
    @company_card_type = CompanyCardType.find_by(
      cnpj: params[:company_card_type][:cnpj],
      card_type_id: params[:company_card_type][:card_type_id]
    )
  end
end
