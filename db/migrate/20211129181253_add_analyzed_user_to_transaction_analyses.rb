class AddAnalyzedUserToTransactionAnalyses < ActiveRecord::Migration[6.1]
  def change
    add_reference :transaction_analyses, :analyzed_user, foreign_key: true, null: true
    # TransactionAnalysis.counter_culture_fix_counts
  end
end
