module ReaisToPointsConversionHelper
  def reais_to_points(card, value)
    (value + (value * (card.company_card_type.conversion_tax / 100))).round
  end
end
