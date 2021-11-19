class CreateAnalysisResults < ActiveRecord::Migration[6.1]
  def change
    execute "CREATE SCHEMA meduza;"
    enable_extension 'citext'
    create_table :analysis_results do |t|
      t.citext :address, null: false
      t.integer :risk_confidence, null: false
      t.integer :risk_level, null: false
      t.jsonb :raw_response, null: false

      t.timestamps
    end

    add_index :analysis_results, :address
  end
end
