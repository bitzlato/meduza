class RemoveAnalyzedUsersToTransactionAnalysis < ActiveRecord::Migration[6.1]
  def change
    remove_column :transaction_analyses, :analyzed_user_id
  end
end
