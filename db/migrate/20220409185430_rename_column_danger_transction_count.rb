class RenameColumnDangerTransctionCount < ActiveRecord::Migration[6.1]
  def change
    rename_column :analyzed_users, :danger_transctions_count, :danger_transactions_count
  end
end
