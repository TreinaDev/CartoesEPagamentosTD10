module ReaisToPointsConversionHelper
  def reais_to_points(card, value)
    (value * card.company_card_type.conversion_tax).round
  end
end
