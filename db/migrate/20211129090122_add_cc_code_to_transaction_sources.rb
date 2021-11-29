class AddCcCodeToTransactionSources < ActiveRecord::Migration[6.1]
  def change
    add_column :transaction_sources, :cc_code, :string

    add_index :transaction_sources, [:name, :cc_code], unique: true

    change_column_null :transaction_sources, :cc_code, false
  end
end
