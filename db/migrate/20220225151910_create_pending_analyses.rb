class CreatePendingAnalyses < ActiveRecord::Migration[6.1]
  def change
    create_table :pending_analyses do |t|
      t.string :address_transaction, null: false
      t.string :is_address, null: false
      t.string :state, null: false, default: :pending
      t.string :cc_code, null: false
      t.string :routing_key
      t.string :correlation_id
      t.string :source, null: false

      t.timestamps
    end

    remove_column :transaction_analyses, :source
    remove_column :transaction_analyses, :state
    add_reference :transaction_analyses, :pending_analyses
  end
end
