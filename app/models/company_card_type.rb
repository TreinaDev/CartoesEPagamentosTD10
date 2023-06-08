class CompanyCardType < ApplicationRecord
  belongs_to :card_type

  enum status: { blocked: 1, available: 3 }
end
