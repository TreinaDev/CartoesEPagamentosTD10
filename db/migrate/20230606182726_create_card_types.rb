class CreateCardTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :card_types do |t|
      t.string :name
      t.string :icon
      t.integer :start_points

      t.timestamps
    end
  end
end
