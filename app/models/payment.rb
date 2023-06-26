class Payment < ApplicationRecord
  include ReaisToPointsConversionHelper
  has_many :errors_associations, dependent: :restrict_with_exception
  enum status: { pending: 0, approved: 3, rejected: 5, pre_approved: 2, pre_rejected: 4 }

  validates :order_number, :total_value, :descount_amount, :final_value,
            :card_number, :cpf, :status, :code, :payment_date, presence: true
  validates :code, uniqueness: true
  validates :code, length: { is: 10 }

  before_validation :generate_code, on: :create
  after_create :pre_approve

  def format_cpf(cpf)
    cpf.gsub(/\A(\d{3})(\d{3})(\d{3})(\d{2})\Z/, '\\1.\\2.\\3-\\4')
  end

  def format_money(value)
    format('%.2f', value).sub('.', ',')
  end

  def check_balance(card_number)
    Card.find_by(number: card_number).points
  end

  def get_final_balance(payment)
    card = Card.find_by(number: payment.card_number)
    points = check_balance(card_number)
    points - reais_to_points(card, final_value)
  end

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(10).upcase
  end

  def check_card_valid
    card = Card.find_by(number: card_number)
    if card.nil?
      ErrorsAssociation.create(payment_id: id, error_message_id: 1)
      return false
    end
    true
  end

  def pre_approve
    card = Card.find_by(number: card_number)
    c_cv = check_card_valid
    if c_cv
      c_cpf = check_cpf(card.cpf, cpf)
      c_cs = check_status(card.status)
      c_cb = check_card_balance(card, final_value)
      return pre_approved! if c_cpf && c_cs && c_cb
    end
    pre_rejected!
  end

  def check_status(status)
    if status != 'active'
      ErrorsAssociation.create(payment_id: id, error_message_id: 2)
      return false
    end
    true
  end

  def check_cpf(card_cpf, order_cpf)
    if card_cpf != order_cpf
      ErrorsAssociation.create(payment_id: id, error_message_id: 3)
      return false
    end
    true
  end

  def check_card_balance(card, value)
    conversion_for_points = reais_to_points(card, value)
    cashback = query_valid_cashback
    conversion_for_points -= cashback.amount if cashback.present?
    return true if card.points >= conversion_for_points

    false if ErrorsAssociation.create(payment_id: id, error_message_id: 4)
  end

  def query_valid_cashback
    Cashback.joins(:cashback_rule)
            .where("DATE(cashbacks.created_at, '+' || cashback_rules.days_to_use || ' days') >= ?", DateTime.now)
            .where(used: false)
  end
end
