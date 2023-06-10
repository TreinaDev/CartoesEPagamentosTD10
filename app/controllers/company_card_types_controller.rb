class CompanyCardTypesController < ApplicationController
  before_action :fetch_company_card_type, only: %i[enable disable]

  def create
    company_card_type = CompanyCardType.new(company_card_type_params)

    if company_card_type.save
      redirect_to company_path(params[:company_id]), notice: I18n.t('.notices.company_card_type_created')
    else
      redirect_to company_path(params[:company_id]), notice: company_card_type.errors.full_messages[0]
    end
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

  def fetch_company_card_type
    @company_card_type = CompanyCardType.find_by(company_card_type_params)
  end
end
