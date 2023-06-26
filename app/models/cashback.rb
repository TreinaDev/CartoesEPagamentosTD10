class Cashback < ApplicationRecord
  belongs_to :card
  belongs_to :cashback_rule
  belongs_to :payment
end
