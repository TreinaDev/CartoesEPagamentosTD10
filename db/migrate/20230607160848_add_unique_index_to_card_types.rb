class AddUniqueIndexToCardTypes < ActiveRecord::Migration[7.0]
  def change
    add_index :card_types, :name, unique: true
    add_index :card_types, :icon, unique: true
  end
end
