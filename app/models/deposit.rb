class Deposit < ApplicationRecord
  self.table_name = :deposit

  belongs_to :user
  belongs_to :wallet
  belongs_to :blockchain_tx
end
