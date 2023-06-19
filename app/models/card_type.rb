class CardType < ApplicationRecord
  has_many :company_card_types, dependent: :restrict_with_exception
  has_one_attached :icon

  validates :name, :icon, :start_points, presence: true
  validates :name, uniqueness: true
  validate :icon_image_type

  scope :enabled, -> { where(emission: true) }
  scope :disabled, -> { where(emission: false) }

  private

  def icon_image_type
    return if icon.present? && icon.content_type =~ %r{^image/(jpeg|gif|png|svg\+xml)$}

    errors.add(:icon, 'é um tipo de imagem inválida')
  end
end
