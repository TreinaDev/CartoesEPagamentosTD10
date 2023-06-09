class CompaniesController < ApplicationController
  def index
    @companies = Company.all
  end

  def show
    @company = Company.find(params[:id])
    @card_types = CardType.all # CardType.enabled
    @company_card_types = CompanyCardType.where(cnpj: @company.registration_number)
  end
  # TODO verificar se é possivel passar informações extras de uma view para outra via params. 
end
