class CompanyCardType < ApplicationRecord
  belongs_to :card_type
  enum status: { pending: 0, active: 5}
end
