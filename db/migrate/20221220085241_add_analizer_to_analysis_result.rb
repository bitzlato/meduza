class AddAnalizerToAnalysisResult < ActiveRecord::Migration[6.1]
  def change
    add_column :analysis_results, :analyzer, :string
    AnalysisResult.update_all(analyzer: ValegaAnalyzer::ANALYZER_NAME)
  end
end
