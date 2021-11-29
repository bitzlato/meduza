class BlockchainTx < ApplicationRecord
  self.table_name = :blockchain_tx

  has_many :transaction_analyses

  has_one :deposit
  has_one :withdrawal
  has_one :deposit_user, through: :deposit, source: :user
  has_one :withdraw_user, through: :withdraw, source: :user

  scope :receive, -> { where("source ->> 'category' = 'receive'") }

  def user
    deposit_user || withdraw_user
  end
end
