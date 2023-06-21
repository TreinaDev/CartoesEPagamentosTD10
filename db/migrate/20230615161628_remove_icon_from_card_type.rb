class RemoveIconFromCardType < ActiveRecord::Migration[7.0]
  def change
    remove_column :card_types, :icon, type: :string
  end
end
