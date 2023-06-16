class CreateExtracts < ActiveRecord::Migration[7.0]
  def change
    create_table :extracts do |t|
      t.datetime :date
      t.string :type
      t.integer :value
      t.string :description
      t.references :card, null: false, foreign_key: true

      t.timestamps
    end
  end
end
