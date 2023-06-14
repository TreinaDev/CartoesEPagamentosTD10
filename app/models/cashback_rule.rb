class CashbackRule < ApplicationRecord
  validates :minimum_amount_points, :cashback_percentage, :days_to_use, presence: true
  validates :minimum_amount_points, :cashback_percentage, :days_to_use, numericality: { only_integer: true, greater_than: 0 }
  validates :cashback_percentage, uniqueness: { scope: [:minimum_amount_points, :days_to_use], message: 'A regra de cashback já existe'}
end
