class AddCcCodeToAnalysisResults < ActiveRecord::Migration[6.1]
  def change
    add_column :analysis_results, :cc_code, :string
    AnalysisResult.find_each do |ar|
      cc_code = BlockchainTx.find_by_txid(ar.address_transaction).try(:cc_code)
      ar.update cc_code: cc_code
    end
  end
end
