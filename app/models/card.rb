class Card < ApplicationRecord
  belongs_to :company_card_type
  enum status: { active: 0, inactive: 5 }
  attribute :status, default: :active
  validates :cpf, :number, :points, presence: true
  validate :unique_cpf_active_card
  validate :valid_available_card_type, on: :create

  before_validation :generate_number
  before_validation :set_initial_points

  private

  def valid_available_card_type
    return unless company_card_type_id

    company_card_type = CompanyCardType.find(company_card_type_id)
    errors.add(:company_card_type, 'não está disponível.') unless company_card_type.status == 'active'
  end

  def unique_cpf_active_card
    cards = Card.where(cpf:)
    active_card = cards.where(status: :active)
    errors.add(:cpf, 'já possui um cartão ativo.') unless active_card.empty?
  end

  def generate_number
    self.number = SecureRandom.random_number(10**20).to_s.rjust(20, '0')
  end

  def set_initial_points
    return unless company_card_type_id

    self.points = company_card_type.card_type.start_points
  end
end
