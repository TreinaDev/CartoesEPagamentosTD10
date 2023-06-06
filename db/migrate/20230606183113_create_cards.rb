class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.string :number
      t.string :cpf
      t.integer :points
      t.integer :status
      t.references :card_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
