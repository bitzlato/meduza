class BlockchainTx < BitzlatoRecord
  self.table_name = :blockchain_tx

  has_many :transaction_analyses, foreign_key: :txid, primary_key: :txid

  has_one :deposit
  has_one :withdrawal
  has_one :deposit_user, through: :deposit, source: :user
  has_one :withdraw_user, through: :withdrawal, source: :user

  scope :receive, -> { where("source ->> 'category' = 'receive' or source ->> 'category' = 'both'") }

  def user
    deposit_user || withdraw_user
  end

  def receive?
    return false if source.nil?
    %w[receive both].include? source.fetch('category')
  end

  def amount
    (source || {}).dig('amount')
  end
end
