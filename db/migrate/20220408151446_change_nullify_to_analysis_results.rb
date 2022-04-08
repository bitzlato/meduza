class ChangeNullifyToAnalysisResults < ActiveRecord::Migration[6.1]
  def change
    change_column_null :analysis_results, :risk_confidence, true
    change_column_null :analysis_results, :risk_level, true
  end
end
