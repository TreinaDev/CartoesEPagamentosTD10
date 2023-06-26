class CashbackRule < ApplicationRecord
  has_many :company_card_types, dependent: nil

  validates :minimum_amount_points, :days_to_use, numericality: { only_integer: true, greater_than: 0 }
  validates :cashback_percentage, numericality: { only_number: true, greater_than: 0, less_than: 100 }
  validates :cashback_percentage, uniqueness: {
    scope: %i[minimum_amount_points days_to_use],
    message: I18n.t('.activerecord.errors.models.cashback_rule.attributes.cashback_percentage.uniqueness')
  }

  def description
    I18n.t(
      '.activerecord.functions.description',
      minimum_amount_points:,
      cashback_percentage: strip_trailing_zero(cashback_percentage),
      days_to_use:
    )
  end

  private

  def strip_trailing_zero(number)
    number.to_s.sub(/\.?0+$/, '')
  end
end
