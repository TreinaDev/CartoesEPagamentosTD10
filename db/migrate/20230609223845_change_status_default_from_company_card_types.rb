class ChangeStatusDefaultFromCompanyCardTypes < ActiveRecord::Migration[7.0]
  def change
    change_column_default :company_card_types, :status, 1
  end
end
