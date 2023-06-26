class Deposit < ApplicationRecord
  belongs_to :card

  before_validation :generate_code, on: :create

  private

  def generate_code
    self.deposit_code = SecureRandom.alphanumeric(8).upcase
  end
end
