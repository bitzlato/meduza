class AddAnalizerToAnalysisResult < ActiveRecord::Migration[6.1]
  def change
    add_column :analysis_results, :analyzer, :string
  end
end
