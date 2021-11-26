class ChangeRiskConfidenceTypeInTranscations < ActiveRecord::Migration[6.1]
  def change
    change_column :transaction_analyses, :risk_confidence, :numeric
    TransactionAnalysis.delete_all
  end
end
