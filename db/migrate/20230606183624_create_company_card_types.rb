class CreateCompanyCardTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :company_card_types do |t|
      t.integer :status
      t.string :cnpj
      t.references :card_type, null: false, foreign_key: true
      t.decimal :conversion_tax, precision: 4, scale: 2

      t.timestamps
    end
  end
end
