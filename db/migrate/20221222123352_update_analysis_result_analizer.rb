class UpdateAnalysisResultAnalizer < ActiveRecord::Migration[6.1]
  def up
    AnalysisResult.in_batches.update_all(analyzer: ValegaAnalyzer::ANALYZER_NAME)
  end
end
