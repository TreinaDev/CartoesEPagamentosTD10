class CardType < ApplicationRecord
  validates :name, :icon, :start_points, presence: true
  validates :name, :icon, uniqueness: true
end
