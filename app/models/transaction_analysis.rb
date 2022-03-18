class TransactionAnalysis < ApplicationRecord
  upsert_keys [:txid]

  # TODO renale to last_analysis_result
  belongs_to :analysis_result
  belongs_to :blockchain_tx, primary_key: :txid, foreign_key: :txid, optional: true

  has_many :deposits, through: :blockchain_tx
  has_many :withdrawals, through: :blockchain_tx
  has_many :deposit_users, through: :deposits, source: :user
  has_many :withdrawals_users, through: :withdrawals, source: :user

  delegate :amount, to: :blockchain_tx, allow_nil: true
  delegate :risk_msg, :transaction_entity_name, to: :analysis_result

  DIRECTIONS = %w[income outcome both unknown internal]
  validates :direction, inclusion: { in: DIRECTIONS }, if: :direction?

  # after_save :update_blockchain_tx_status

  before_create do
    self.direction = detect_direction
  end

  def self.actual?(txid)
    ta = find_by(txid: txid)
    return false if ta.nil?

    ta.updated_at > 1.week.ago
  end

  def to_s
    [cc_code, txid, 'risk_level:' + risk_level, risk_msg, transaction_entity_name].join('; ')
  end

  def detect_direction
    withdrawals_count = withdrawals.count
    deposits_count = deposits.count

    if withdrawals_count>0 && deposits_count>0
      :both
    elsif withdrawals_count>0
      :outcome
    elsif deposits_count>0
      :income
    else
      :unknown
    end
  end

  def update_blockchain_tx_status
    BlockchainTx.where(cc_code: cc_code, txid: txid).update_all(
      meduza_status: {
        transaction_analysis_id: id,
        analysis_result_id: analysis_result_id,
        risk_level: risk_level,
        risk_confidence: risk_confidence,
        created_at: created_at,
        updated_at: Time.zone.now
      }
    )
  end
end
