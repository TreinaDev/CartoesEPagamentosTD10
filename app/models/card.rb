class Card < ApplicationRecord
  belongs_to :company_card_type
  enum status: { active: 0, inactive: 5, blocked: 10 }
  attribute :status, default: :active
  validates :cpf, :number, :points, presence: true
  validate :unique_cpf_active_card, on: :create
  validate :valid_available_card_type, on: :create
  validate :check_block, on: :update
  validate :check_recharge_permission, on: :update

  before_validation :generate_number, on: :create
  before_validation :set_initial_points, on: :create

  private

  def valid_available_card_type
    return unless company_card_type_id

    company_card_type = CompanyCardType.find(company_card_type_id)
    errors.add(:company_card_type, 'não está disponível') unless company_card_type.status == 'active'
  end

  def unique_cpf_active_card
    cards = Card.where(cpf:)
    active_card = cards.where(status: :active)
    errors.add(:cpf, 'já possui um cartão ativo') unless active_card.empty?
  end

  def check_block
    card = Card.find(id)
    errors.add(:status, 'bloqueado não permite alterações no cartão') if card.status == 'blocked'
  end

  def check_recharge_permission
    errors.add(:status, 'inativo não permite recargas') if status == 'inactive'
  end

  def generate_number
    self.number = SecureRandom.random_number(10**20).to_s.rjust(20, '0')
  end

  def set_initial_points
    return unless company_card_type_id

    self.points = company_card_type.card_type.start_points
  end
end
