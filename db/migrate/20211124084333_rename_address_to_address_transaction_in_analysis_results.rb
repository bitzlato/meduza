class RenameAddressToAddressTransactionInAnalysisResults < ActiveRecord::Migration[6.1]
  def change
    rename_column :analysis_results, :address, :address_transaction
  end
end
