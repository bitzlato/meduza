class RemoveInputAddressesInTransactionSources < ActiveRecord::Migration[6.1]
  def change
    remove_column :transaction_analyses, :input_addresses
  end
end
