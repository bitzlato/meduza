class AddIndexToRiskLevelsInAnalzyedUsers < ActiveRecord::Migration[6.1]
  def change
    add_index :analyzed_users, :risk_level_3_count
    add_index :analyzed_users, :risk_level_2_count
    add_index :analyzed_users, :risk_level_1_count
  end
end
