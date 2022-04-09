class RemoveRiskCountersInAnalyzedUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :analyzed_users, :risk_level_1_count
    remove_column :analyzed_users, :risk_level_2_count
    remove_column :analyzed_users, :risk_level_3_count
  end
end
