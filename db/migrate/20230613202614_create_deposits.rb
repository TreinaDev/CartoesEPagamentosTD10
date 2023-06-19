class CreateDeposits < ActiveRecord::Migration[7.0]
  def change
    create_table :deposits do |t|
      t.references :card, null: false, foreign_key: true
      t.integer :amount
      t.string :description
      t.string :deposit_code

      t.timestamps
    end
  end
end
