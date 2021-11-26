class BlockchainTx < ApplicationRecord
  self.table_name = :blockchain_tx

  has_many :transaction_analyses

  scope :income, -> { where("source ->> 'category' = 'receive'") }
end
