class CreateAddressAnalyses < ActiveRecord::Migration[6.1]
  def change
    create_table :address_analyses do |t|
      t.citext :address, null: false
      t.integer :risk_level, null: false
      t.integer :risk_confidence, null: false
      t.references :analysis_result, null: false, foreign_key: true

      t.timestamps
    end

    add_index :address_analyses, :address, unique: true
  end
end
