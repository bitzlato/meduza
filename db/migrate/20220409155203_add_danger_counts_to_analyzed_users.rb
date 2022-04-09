class AddDangerCountsToAnalyzedUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :analyzed_users, :danger_transctions_count, :integer, null: false, default: 0
    add_column :analyzed_users, :danger_addresses_count, :integer, null: false, default: 0
  end
end
