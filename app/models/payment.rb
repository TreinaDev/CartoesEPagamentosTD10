class Payment < ApplicationRecord
  has_many :errors_associations, dependent: :restrict_with_exception
  enum status: { pending: 0, approved: 3, rejected: 5, pre_approved: 2, pre_rejected: 4 }

  validates :order_number, :total_value, :descount_amount, :final_value,
            :card_number, :cpf, :status, :code, :payment_date, presence: true
  validates :code, uniqueness: true
  validates :code, length: { is: 10 }

  before_validation :generate_code, on: :create
  after_create :check_errors
  after_create :pre_approve

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(10).upcase
  end

  def check_errors
    card = Card.find_by(number: card_number)
    if card.nil?
      ErrorsAssociation.create(payment_id: id, error_message_id: 1)
    else
      check_status(card.status)
      check_cpf(card.cpf, cpf)
      check_card_balance(card, final_value)
    end
  end

  def pre_approve
    self.status = if check_cpf(card_cpf: card.cpf, order_cpf: cpf) &&
                     check_satus(status: card.status) &&
                     check_card_balance(card:, value: final_value)
                    2
                  else
                    4
                  end
  end

  def check_status(status)
    return ErrorsAssociation.create(payment_id: id, error_message_id: 2) if status != 'active'

    true
  end

  def check_cpf(card_cpf, order_cpf)
    return ErrorsAssociation.create(payment_id: id, error_message_id: 3) if card_cpf != order_cpf

    true
  end

  def check_card_balance(card, value)
    conversion_for_points = (value - (value * (card.company_card_type.conversion_tax / 100))).round
    cashback = get_valid_cashback
    conversion_for_points -= cashback.amount if cashback.present?

    if conversion_for_points >= card.points
      true
    elsif card.points < conversion
      ErrorsAssociation.create(payment_id: id, error_message_id: 4)
    end
  end

  def query_valid_cashback
    Cashback.joins(:cashback_rule)
            .where("DATE(cashbacks.created_at, '+' || cashback_rules.days_to_use || ' days') >= ?", DateTime.now)
            .where(used: false)
            .where(card: { cpf: })
  end
end
