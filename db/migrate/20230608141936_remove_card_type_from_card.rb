class RemoveCardTypeFromCard < ActiveRecord::Migration[7.0]
  def change
    remove_reference :cards, :card_type, null: false, foreign_key: true
  end
end
