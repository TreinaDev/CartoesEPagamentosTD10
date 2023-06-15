class CashbackRule < ApplicationRecord
  validates :minimum_amount_points, :cashback_percentage, :days_to_use, presence: true
  validates :minimum_amount_points, :cashback_percentage, :days_to_use, numericality: { only_number: true,
                                                                                        greater_than: 0 }
  validates :cashback_percentage, uniqueness: {
    scope: %i[minimum_amount_points days_to_use],
    message: I18n.t('.activerecord.errors.models.cashback_rule.attributes.cashback_percentage.uniqueness') }
end
