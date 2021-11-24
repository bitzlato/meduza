class ChangeTransactionAnalyses < ActiveRecord::Migration[6.1]
  def change
    TransactionAnalysis.delete_all
    rename_column :transaction_analyses, :min_risk_level, :risk_level
    add_reference :transaction_analyses, :analysis_result
    add_column :transaction_analyses, :risk_confidence, :integer, null: false
  end
end
