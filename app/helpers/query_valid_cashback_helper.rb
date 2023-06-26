module QueryValidCashbackHelper
  def query_valid_cashback(cpf)
    Cashback.joins(:cashback_rule)
            .where("DATE(cashbacks.created_at, '+' || cashback_rules.days_to_use || ' days') >= ?", DateTime.now)
            .where(used: false)
            .where(card: { cpf: })
  end
end
