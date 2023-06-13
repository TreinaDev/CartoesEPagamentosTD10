class CardType < ApplicationRecord
  has_many :company_card_types, dependent: :restrict_with_exception
  validates :name, :icon, :start_points, presence: true
  validates :name, :icon, uniqueness: true

  scope :enabled, -> { where(emission: true) }
  scope :disabled, -> { where(emission: false) }
end
