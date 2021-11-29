class AddCcCodeToTransactionSources < ActiveRecord::Migration[6.1]
  def change
    add_column :transaction_sources, :cc_code, :string

    TransactionSource.update_all cc_code: 'BTC'

    add_index :transaction_sources, [:name, :cc_code], unique: true

    change_column_null :transaction_sources, :cc_code, false

    Daemons::IncomeTransactionsAnalyser::ANALYZABLE_CODES.each do |code|
      TransactionSource.upsert name: "bitzlato p2p", last_processed_blockchain_tx_id: 2_550_000, cc_code: code
    end
  end
end
