class Api::V1::CompanyCardTypesController < Api::V1::ApiController
  def index
    company = CompanyCardType.where(cnpj: params[:cnpj])
    card_types = company.where(status: :active)
    card_types = format_card_type_body(card_types)
    render status: :ok, json: card_types
  end

  private

  def format_card_type_body(card_types)
    card_types.map do |c|
      {
        company_card_type_id: c.id,
        name: c.card_type.name,
        icon: c.card_type.icon,
        start_points: c.card_type.start_points,
        conversion_tax: c.conversion_tax.to_f
      }
    end
  end
end
