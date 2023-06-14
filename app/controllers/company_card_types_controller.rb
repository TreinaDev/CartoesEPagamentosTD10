class CompanyCardTypesController < ApplicationController
  before_action :set_company_card_type, only: %i[enable disable]

  def create
    company_card_type = CompanyCardType.new(company_card_type_params)

    return unless company_card_type.save

    redirect_to company_path(params[:company_id]), notice: I18n.t('.notices.company_card_type_created')
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
    params.require(:company_card_type).permit(:cnpj, :card_type_id)
  end

  def set_company_card_type
    @company_card_type = CompanyCardType.find_by(company_card_type_params)
  end
end
