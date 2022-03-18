class ChangeTransactionAnalysisUniqueIndex < ActiveRecord::Migration[6.1]
  def change
    add_index :transaction_analyses, [:cc_code, :txid], unique: true
    remove_index :transaction_analyses, name: :index_transaction_analyses_on_txid
  end
end
