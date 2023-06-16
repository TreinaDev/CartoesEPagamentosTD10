class RenameColumnFromExtract < ActiveRecord::Migration[7.0]
  def change
    rename_column :extracts, :type, :operation_type
  end
end
