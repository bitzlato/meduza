class AddIsReplyiedToPendingAnalyses < ActiveRecord::Migration[6.1]
  def change
    add_column :pending_analyses, :replied_at, :timestamp
    PendingAnalysis.where(state: %i[done skippet]).update_all 'replied_at = updated_at'
  end
end
