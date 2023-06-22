class CompanyCardType < ApplicationRecord
  belongs_to :card_type
  belongs_to :cashback_rule, optional: true

  validates :cnpj, :status, :conversion_tax, presence: true
  validates :card_type, uniqueness: { scope: :cnpj }
  enum status: { active: 1, inactive: 3 }
end
