class AddTypeToAnalysisResults < ActiveRecord::Migration[6.1]
  def change
    add_column :analysis_results, :type, :string

    AnalysisResult.update_all "type=raw_response->>'type'"

    change_column_null :analysis_results, :type, false

    remove_column :pending_analyses, :is_address

    add_column :pending_analyses, :type, :string
  end
end
