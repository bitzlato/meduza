class CreateDangerTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :danger_transactions do |t|
      t.references :analyzed_user, null: false, foreign_key: true
      t.string :txid, null: false
      t.string :cc_code, null: false

      t.timestamps
    end

    add_index :danger_transactions, [:analyzed_user_id, :cc_code, :txid], unique: true, name: :danger_transactions_uniq_index
    add_index :danger_transactions, :txid
  end
end
