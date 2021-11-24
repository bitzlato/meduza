class ChangeTranscationAnalysesInputAddress < ActiveRecord::Migration[6.1]
  def change
    change_column_null :transaction_analyses, :input_addresses, true
  end
end
