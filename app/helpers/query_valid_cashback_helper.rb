module QueryValidCashbackHelper
  def query_valid_cashback(cpf)
    Cashback.joins(:cashback_rule)
            .joins('JOIN cards ON cards.id = cashbacks.card_id')
            .where("DATE(cashbacks.created_at, '+' || cashback_rules.days_to_use || ' days') >= ?", DateTime.now)
            .where(used: false)
            .where(cards: { cpf: }).first
  end
end
