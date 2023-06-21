class Api::V1::CompanyCardTypesController < Api::V1::ApiController
  before_action :authenticate_api_key
  def index
    company = CompanyCardType.where(cnpj: params[:cnpj])
    company_card_types = company.where(status: :active)
    company_card_types = format_card_type_body(company_card_types)
    render status: :ok, json: company_card_types
  end

  private

  def format_card_type_body(company_card_types)
    company_card_types.map do |c|
      {
        company_card_type_id: c.id,
        name: c.card_type.name,
        icon: url_for(c.card_type.icon),
        start_points: c.card_type.start_points,
        conversion_tax: c.conversion_tax.to_f
      }
    end
  end
end
