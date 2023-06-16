class AddPaymentDateToPayment < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :payment_date, :date
  end
end
