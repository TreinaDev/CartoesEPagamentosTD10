class AddEmissionToCardType < ActiveRecord::Migration[7.0]
  def change
    add_column :card_types, :emission, :boolean, default: true
  end
end
