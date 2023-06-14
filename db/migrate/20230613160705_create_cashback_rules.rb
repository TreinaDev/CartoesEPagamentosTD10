class CreateCashbackRules < ActiveRecord::Migration[7.0]
  def change
    create_table :cashback_rules do |t|
      t.integer :minimum_amount_points
      t.decimal :cashback_percentage, precision: 4, scale: 2
      t.integer :days_to_use

      t.timestamps
    end
  end
end
