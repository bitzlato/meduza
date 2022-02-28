class AddMetaToPendingAnalyses < ActiveRecord::Migration[6.1]
  def change
    add_column :pending_analyses, :meta, :jsonb
  end
end
