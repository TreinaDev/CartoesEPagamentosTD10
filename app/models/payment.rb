class Payment < ApplicationRecord
  enum status: { pending: 0, approved: 3, rejected: 5 }
end
