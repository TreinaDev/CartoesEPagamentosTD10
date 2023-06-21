class CreateErrorMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :error_messages do |t|
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end
