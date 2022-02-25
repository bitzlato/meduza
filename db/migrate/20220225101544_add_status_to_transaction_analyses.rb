class AddStatusToTransactionAnalyses < ActiveRecord::Migration[6.1]
  def change
    add_column :transaction_analyses, :state, :string
    remove_column :transaction_analyses, :blockchain_tx_id if Rails.env.production?
    add_column :transaction_analyses, :meta, :jsonb, null: false, default: {}
    add_column :transaction_analyses, :source, :string

    TransactionAnalysis.update_all source: :p2p, state: :done
    change_column_null :transaction_analyses, :source, false
    change_column_null :transaction_analyses, :state, false
  end
end
