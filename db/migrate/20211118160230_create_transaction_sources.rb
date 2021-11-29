class CreateTransactionSources < ActiveRecord::Migration[6.1]
  def change
    create_table :transaction_sources do |t|
      t.string :name
      t.bigint :last_processed_blockchain_tx_id

      t.timestamps
    end
  end
end
