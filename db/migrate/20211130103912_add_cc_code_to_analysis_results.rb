class AddCcCodeToAnalysisResults < ActiveRecord::Migration[6.1]
  def change
    add_column :analysis_results, :cc_code, :string
  end
end
