class AddDirectionToTransactionAnalysis < ActiveRecord::Migration[6.1]
  def change
    add_column :transaction_analyses, :direction, :string
  end
end
