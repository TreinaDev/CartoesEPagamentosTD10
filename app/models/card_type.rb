class CardType < ApplicationRecord
  validates :name, :icon, :start_points, presence: true
  validates :name, :icon, uniqueness: true

  def self.enabled
    CardType.where(emission: true)
  end

  def self.disabled
    CardType.where(emission: false)
  end

end