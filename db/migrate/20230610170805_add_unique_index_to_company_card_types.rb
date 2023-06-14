class AddUniqueIndexToCompanyCardTypes < ActiveRecord::Migration[7.0]
  def change
    add_index :company_card_types, [:card_type_id, :cnpj], unique: true
  end
end
