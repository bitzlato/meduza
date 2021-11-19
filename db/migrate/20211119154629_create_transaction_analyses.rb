class CreateTransactionAnalyses < ActiveRecord::Migration[6.1]
  def change
    create_table :transaction_analyses do |t|
      t.citext :txid, null: false
      t.string :cc_code, null: false
      t.integer :min_risk_level, null: false
      t.jsonb :input_addresses, null: false

      t.timestamps
    end

    add_index :transaction_analyses, :txid, unique: true
  end
end
