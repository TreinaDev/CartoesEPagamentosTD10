class CompanyCardType < ApplicationRecord
  belongs_to :card_type

  validates :cnpj, :status, :card_type, presence: true
  validates :card_type, uniqueness: { scope: :cnpj, message: 'já disponível para essa empresa.' }

  enum status: { available: 1, unavailable: 3 }
end
