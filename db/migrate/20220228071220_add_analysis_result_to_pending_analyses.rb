class AddAnalysisResultToPendingAnalyses < ActiveRecord::Migration[6.1]
  def change
    add_reference :pending_analyses, :analysis_result, null: true, foreign_key: true
  end
end
