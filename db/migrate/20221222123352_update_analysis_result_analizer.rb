class UpdateAnalysisResultAnalizer < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def up
    # rubocop:disable Rails/SkipsModelValidations
    AnalysisResult.in_batches(of: 10_000).update_all(analyzer: ValegaAnalyzer::ANALYZER_NAME)
    # rubocop:enable Rails/SkipsModelValidations
  end
end
