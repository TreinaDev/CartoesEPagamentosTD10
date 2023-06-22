class AddCashbackRuleToCompanyCardTypes < ActiveRecord::Migration[7.0]
  def change
    add_reference :company_card_types, :cashback_rule, foreign_key: true
  end
end
