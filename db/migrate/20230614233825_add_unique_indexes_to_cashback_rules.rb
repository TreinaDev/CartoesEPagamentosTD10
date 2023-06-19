class AddUniqueIndexesToCashbackRules < ActiveRecord::Migration[7.0]
  def change
    add_index :cashback_rules, [:cashback_percentage, :minimum_amount_points, :days_to_use], unique: true, name: 'index_cashback_rules_on_minimum_amount_points_and_days_to_use'
  end
end
