class CreateTransactionSources < ActiveRecord::Migration[6.1]
  def change
    create_table :transaction_sources do |t|
      t.string :name
      t.bigint :last_processed_blockchain_tx_id

      t.timestamps
    end
    TransactionSource.create!(name: 'bitzlato p2p', last_processed_blockchain_tx_id: 2_566_250)
  end
end
