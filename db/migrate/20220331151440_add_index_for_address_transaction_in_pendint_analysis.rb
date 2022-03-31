class AddIndexForAddressTransactionInPendintAnalysis < ActiveRecord::Migration[6.1]
  def change
    add_index :pending_analyses, %i[source state address_transaction], name: :pending_analysis_adress_transaction_idx
  end
end
