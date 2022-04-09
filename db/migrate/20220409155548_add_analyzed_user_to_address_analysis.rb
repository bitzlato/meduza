class AddAnalyzedUserToAddressAnalysis < ActiveRecord::Migration[6.1]
  def change
    add_column :address_analyses, :analyzed_user_ids, :jsonb, null: false, default: []
  end
end
