class Payment < ApplicationRecord
  has_many :errors_associations, dependent: :restrict_with_exception
  enum status: { pending: 0, approved: 3, rejected: 5 }

  validates :order_number, :total_value, :descount_amount, :final_value,
            :card_number, :cpf, :status, :code, :payment_date, presence: true
  validates :code, uniqueness: true
  validates :code, length: { is: 10 }

  before_validation :generate_code, on: :create
  after_create :check_errors

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

  def check_status(status)
    ErrorsAssociation.create(payment_id: id, error_message_id: 2) if status != 'active'
  end

  def check_cpf(card_cpf, order_cpf)
    ErrorsAssociation.create(payment_id: id, error_message_id: 3) if card_cpf != order_cpf
  end

  def check_card_balance(card, value)
    conversion = value * card.company_card_type.conversion_tax
    ErrorsAssociation.create(payment_id: id, error_message_id: 4) if card.points < conversion
  end
end
