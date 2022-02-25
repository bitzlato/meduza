class AddIndexesToTransactionAnalyses < ActiveRecord::Migration[6.1]
  def change
    add_index :transaction_analyses, :state
    add_index :transaction_analyses, :source
  end
end
