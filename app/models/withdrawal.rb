class Withdrawal < ApplicationRecord
  self.table_name = :withdrawal

  belongs_to :user
  belongs_to :wallet
  belongs_to :blockchain_tx
end
