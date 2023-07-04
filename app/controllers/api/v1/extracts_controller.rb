class Api::V1::ExtractsController < Api::V1::ApiController
  def index
    card = Card.find_by(number: params[:card_number])
    return render status: :not_found, json: { errors: 'Cartão não encontrado' } if card.nil?

    extract = Extract.where(card_number: card.number)
    return render status: :ok, json: { message: 'Nenhuma transação registrada' } if extract.empty?

    render status: :ok, json: format_extract(extract)
  end

  private

  def format_extract(extract_items)
    extract_items.map do |c|
      {
        id: c.id,
        date: c.date,
        operation_type: c.operation_type,
        description: c.description,
        value: (c.value).abs
      }
    end
  end
end
