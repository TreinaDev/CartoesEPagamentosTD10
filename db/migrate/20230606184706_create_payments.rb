class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.string :order_number
      t.string :code
      t.integer :total_value
      t.integer :descount_amount
      t.integer :final_value
      t.integer :status
      t.string :cpf
      t.string :card_number

      t.timestamps
    end
  end
end
