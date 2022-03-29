class SetNotNullRiskLevelsInTransactionAnalyses < ActiveRecord::Migration[6.1]
  def change
    change_column_null :transaction_analyses, :risk_level, false
    change_column_null :transaction_analyses, :risk_confidence, false
  end
end
