class CreateErrorsAssociations < ActiveRecord::Migration[7.0]
  def change
    create_table :errors_associations do |t|
      t.references :payment, null: false, foreign_key: true
      t.references :error_message, null: false, foreign_key: true

      t.timestamps
    end
  end
end
