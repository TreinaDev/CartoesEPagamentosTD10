class Card < ApplicationRecord
  belongs_to :company_card_type
  enum status: { active: 0, inactive: 5 }
  attribute :status, default: :active
  validates :cpf, :number, :points, presence: true

  before_validation :generate_number
  before_validation :set_initial_points

  private

  def generate_number
    self.number = SecureRandom.random_number(10**20).to_s.rjust(20, '0')
  end

  def set_initial_points
    return unless company_card_type_id

    self.points = company_card_type.card_type.start_points
  end
end
