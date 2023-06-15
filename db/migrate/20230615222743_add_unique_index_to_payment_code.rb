class AddUniqueIndexToPaymentCode < ActiveRecord::Migration[7.0]
  def change
    add_index :payments, :code, unique: true
  end
end
