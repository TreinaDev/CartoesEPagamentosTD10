class Cashback < ApplicationRecord
  belongs_to :card
  belongs_to :cashback_rule
  belongs_to :payment

  def change_cashback_used(payment, card)
    self.used = true
    save!
    generate_cashback_use_extract(payment, card)
  end

  def self.create_cashback_if_possible(final_value, card, payment)
    return unless final_value >= card.company_card_type.cashback_rule.minimum_amount_points

    cashback_amount = (final_value * card.company_card_type.cashback_rule.cashback_percentage / 100).round
    cashback = Cashback.create!(amount: cashback_amount, payment:,
                                cashback_rule: card.company_card_type.cashback_rule, card:)
    cashback.generate_cashback_extract(payment, card)
  end

  def generate_cashback_extract(payment, card)
    venc = card.company_card_type.cashback_rule.days_to_use
    Extract.create(date: created_at, operation_type: 'cashback_created', value: amount,
                   description: "Cashback #{payment.order_number} Válido por #{venc} dia(s)", card_number: card.number)
  end

  def generate_cashback_use_extract(payment, card)
    Extract.create(date: created_at, operation_type: 'cashback_used', value: amount,
                   description: "Cashback #{self.payment.order_number} usado no pedido #{payment.order_number}", card_number: card.number)
  end
end
