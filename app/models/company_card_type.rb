class CompanyCardType < ApplicationRecord
  belongs_to :card_type

  validates :cnpj, :status, presence: true
  validates :card_type, uniqueness: { scope: :cnpj }

  enum status: { active: 1, inactive: 3 }
end
