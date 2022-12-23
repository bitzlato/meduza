class SetNotNullAnalizer < ActiveRecord::Migration[6.1]
  def change
    change_column_null :analysis_results, :analyzer, false
  end
end
