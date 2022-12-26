class AddBlockchainKey < ActiveRecord::Migration[6.1]
  def change
    add_column :pending_analyses, :blockchain, :string
    add_column :analysis_results, :blockchain, :string
  end
end
