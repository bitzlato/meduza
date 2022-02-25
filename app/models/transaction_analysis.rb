class TransactionAnalysis < ApplicationRecord
  upsert_keys [:txid]

  belongs_to :analysis_result, optional: true

  belongs_to :blockchain_tx, primary_key: :txid, foreign_key: :txid, optional: true
  has_many :deposits, through: :blockchain_tx
  has_many :withdrawals, through: :blockchain_tx
  has_many :deposit_users, through: :deposits, source: :user
  has_many :withdrawals_users, through: :withdrawals, source: :user

  scope :pending, -> { where state: :pending }

  delegate :amount, to: :blockchain_tx, allow_nil: true
  delegate :risk_msg, :transaction_entity_name, to: :analysis_result

  DIRECTIONS = %w[income outcome unknown internal]
  validates :direction, inclusion: { in: DIRECTIONS }, if: :direction?

  def self.actual?(txid)
    ta = find_by(txid: txid)
    return false if ta.nil?

    ta.updated_at > 1.week.ago
  end

  def to_s
    [cc_code, txid, 'risk_level:' + risk_level, risk_msg, transaction_entity_name].join('; ')
  end
end
