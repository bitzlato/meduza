class AddSetAnalysisResultNotNullInTransactionAnalyses < ActiveRecord::Migration[6.1]
  def change
    change_column_null :transaction_analyses, :analysis_result_id, false
  end
end
