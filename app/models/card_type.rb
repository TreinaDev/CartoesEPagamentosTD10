class CardType < ApplicationRecord
  validates :name, :icon, :start_points, presence: true
  validates :name, :icon, uniqueness: true

  scope :enabled, -> { where(emission: true) }
  scope :disabled, -> { where(emission: false) }
end
