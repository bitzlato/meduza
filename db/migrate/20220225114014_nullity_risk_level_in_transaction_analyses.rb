class NullityRiskLevelInTransactionAnalyses < ActiveRecord::Migration[6.1]
  def change
    change_column_null :transaction_analyses, :risk_level, true
    change_column_null :transaction_analyses, :risk_confidence, true
  end
end
