class CardType < ApplicationRecord
  has_many :company_card_types, dependent: :restrict_with_exception
  has_one_attached :icon

  validates :name, :icon, :start_points, presence: true
  validates :name, uniqueness: true
  validate :icon_is_image

  scope :enabled, -> { where(emission: true) }
  scope :disabled, -> { where(emission: false) }

  private

  def icon_is_image
    return if icon.present? && icon.content_type =~ /^image\/(jpeg|gif|png|svg\+xml)$/
    errors.add(:upload, 'Tipo de imagem inválida')
  end
end
