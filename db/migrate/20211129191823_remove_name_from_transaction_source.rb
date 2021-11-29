class RemoveNameFromTransactionSource < ActiveRecord::Migration[6.1]
  def change
    remove_column :transaction_sources, :name
  end
end
