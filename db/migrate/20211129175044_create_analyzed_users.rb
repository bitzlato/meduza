class CreateAnalyzedUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :analyzed_users do |t|
      t.bigint :user_id, null: false
      t.integer :risk_level_1_count, null: false, default: 0
      t.integer :risk_level_2_count, null: false, default: 0
      t.integer :risk_level_3_count, null: false, default: 0

      t.timestamps
    end

    add_index :analyzed_users, :user_id, unique: true, name: :index_analyzed_users_on_user_id_uniq
  end
end
