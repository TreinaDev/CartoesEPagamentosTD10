class AddUniqueIndexToErrorMessageCode < ActiveRecord::Migration[7.0]
  def change
    add_index :error_messages, :code, unique: true
  end
end
