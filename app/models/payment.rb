class Payment < ApplicationRecord
  enum status: { pending: 0, approved: 3, rejected: 5 }

  validates :order_number, :total_value, :descount_amount, :final_value,
            :card_number, :cpf, :status, :code, :payment_date, presence: true
  validates :code, uniqueness: true
  validates :code, length: { is: 10 }
  validates :card_number, length: { is: 20 }

  before_validation :generate_code, on: :create

  def generate_code
    self.code = SecureRandom.alphanumeric(10).upcase
  end
end
