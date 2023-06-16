class RemoveAndAddColumnToExtract < ActiveRecord::Migration[7.0]
  def change
    remove_column :extracts, :card_id
    add_column :extracts, :card_number, :string
  end
end
