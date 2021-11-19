class CreateAnalysisResults < ActiveRecord::Migration[6.1]
  def change
    execute "CREATE SCHEMA if not exists meduza"
    enable_extension 'citext' unless extensions.include?('citext')
    create_table :analysis_results do |t|
      t.citext :address, null: false
      t.decimal :risk_confidence, null: false
      t.integer :risk_level, null: false
      t.jsonb :raw_response, null: false

      t.timestamps
    end

    add_index :analysis_results, :address
  end
end
