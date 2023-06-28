class AddUniqueIndexToCardNumber < ActiveRecord::Migration[7.0]
  def change
    add_index :cards, :number, unique: true
  end
end
