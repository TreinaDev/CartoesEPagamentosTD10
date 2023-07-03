class CompaniesController < ApplicationController
  def index
    companies_data = Company.all
    @companies = companies_data.filter { |c| c.active == true }
  end

  def search
    search = params[:search]
    companies_data = Company.all(search)
    @companies = companies_data.filter { |c| c.active == true }
  end

  def show
    @company = Company.find(params[:id])
    redirect_to companies_path, notice: I18n.t('.companies.index.inactive_company') unless @company.active
    @card_types = CardType.enabled
    @company_card_types = CompanyCardType.where(cnpj: @company.registration_number)
    @linked_card_types = @company_card_types.to_a.map(&:card_type)
    @cashback_rules = CashbackRule.order(:minimum_amount_points)
  end
end
