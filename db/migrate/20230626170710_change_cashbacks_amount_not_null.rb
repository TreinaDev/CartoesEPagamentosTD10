class ChangeCashbacksAmountNotNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :cashbacks, :amount, false
  end
end
