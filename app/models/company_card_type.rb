class CompanyCardType < ApplicationRecord
  belongs_to :card_type

  validates :cnpj, :status, presence: true
  validates :card_type, uniqueness: { scope: :cnpj }

  enum status: { available: 1, unavailable: 3 }
end
