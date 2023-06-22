class CreateCashbacks < ActiveRecord::Migration[7.0]
  def change
    create_table :cashbacks do |t|
      t.integer :amount
      t.boolean :used, default: false, null: false
      t.references :card, null: false, foreign_key: true
      t.references :cashback_rule, null: false, foreign_key: true
      t.references :payment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
