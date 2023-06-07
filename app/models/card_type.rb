class CardType < ApplicationRecord
  has_many :company_card_types, dependent: :restrict_with_exception
end
