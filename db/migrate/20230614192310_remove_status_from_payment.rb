class RemoveStatusFromPayment < ActiveRecord::Migration[7.0]
  def change
    remove_column :payments, :status, :string
  end
end
