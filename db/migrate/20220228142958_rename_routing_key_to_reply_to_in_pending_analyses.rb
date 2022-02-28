class RenameRoutingKeyToReplyToInPendingAnalyses < ActiveRecord::Migration[6.1]
  def change
    rename_column :pending_analyses, :routing_key, :reply_to
  end
end
