class AddUniquenessToBlockchainTxId < ActiveRecord::Migration[6.1]
  def change
    add_index :transaction_analyses, :blockchain_tx_id, unique: true, name: :index_transaction_analyses_on_blockchain_tx_id_uniq
    remove_index :transaction_analyses, name: :index_transaction_analyses_on_blockchain_tx_id
  end
end
