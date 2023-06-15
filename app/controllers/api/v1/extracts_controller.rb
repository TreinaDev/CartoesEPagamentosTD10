class Api::V1::ExtractsController < Api::V1::ApiController
  def index
    extract = Extract.where(card_number: params[:card_number])
    if extract.empty?
      render status: :not_found, json: { errors: 'Extrado não disponível para o cartão' }
    else
      render status: :ok, json: format_extract(extract)
    end
  end

  private

  def format_extract(extract_items)
    extract_items.map do |c|
      {
        id: c.id,
        date: c.date,
        operation_type: c.operation_type,
        description: c.description,
        value: c.value
      }
    end
  end
end
