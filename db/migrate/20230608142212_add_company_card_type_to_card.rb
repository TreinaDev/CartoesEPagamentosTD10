class AddCompanyCardTypeToCard < ActiveRecord::Migration[7.0]
  def change
    add_reference :cards, :company_card_type, null: false, foreign_key: true
  end
end
