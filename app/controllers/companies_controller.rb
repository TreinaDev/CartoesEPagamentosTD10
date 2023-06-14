class CompaniesController < ApplicationController
  def index
    @companies = Company.all
  end

  def show
    @company = Company.find(params[:id])
    @card_types = CardType.enabled
    @company_card_types = CompanyCardType.where(cnpj: @company.registration_number)
    @linked_card_types = @company_card_types.to_a.map(&:card_type)
  end
end
