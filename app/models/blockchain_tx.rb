class BlockchainTx < ApplicationRecord
  self.table_name = :blockchain_tx

  scope :income, -> { where("source ->> 'category' = 'receive'") }
end
