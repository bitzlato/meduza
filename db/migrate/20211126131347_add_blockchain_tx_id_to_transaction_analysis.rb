class AddBlockchainTxIdToTransactionAnalysis < ActiveRecord::Migration[6.1]
  def change
    add_reference :transaction_analyses, :blockchain_tx, null: false, foreign_key: { to_table: 'public.blockchain_tx' }
  end
end
