class AddAnalyzedUserToTransactionAnalysis < ActiveRecord::Migration[6.1]
  def change
    add_reference :transaction_analyses, :analyzed_user, foreign_key: true
  end
end
