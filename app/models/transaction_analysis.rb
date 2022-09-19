class TransactionAnalysis < ApplicationRecord
  upsert_keys [:txid, :cc_code]

  # TODO renale to last_analysis_result
  belongs_to :analysis_result
  belongs_to :blockchain_tx, primary_key: :txid, foreign_key: :txid, optional: true
  belongs_to :analyzed_user, optional: true

  has_many :deposits, through: :blockchain_tx
  has_many :withdrawals, through: :blockchain_tx
  has_many :deposit_users, through: :deposits, source: :user
  has_many :withdrawals_users, through: :withdrawals, source: :user

  delegate :amount, to: :blockchain_tx, allow_nil: true
  delegate :risk_msg, :entity_name, :entity_dir_name, to: :analysis_result, allow_nil: true

  DIRECTIONS = %w[income outcome both unknown internal]
  validates :direction, inclusion: { in: DIRECTIONS }, if: :direction?

  validates :txid, uniqueness: { scope: :cc_code }, presence: true

  validates :risk_level, presence: true
  validates :risk_confidence, presence: true

  before_create :update_analyzed_user

  before_create do
    self.direction = detect_direction
  end

  before_save do
    self.risk_level = analysis_result.try(:risk_level)
    self.risk_confidence = analysis_result.try(:risk_confidence)
  end

  after_save :update_danger_transaction, if: :analyzed_user

  def self.actual?(txid)
    ta = find_by(txid: txid)
    return false if ta.nil?

    ta.updated_at > 1.week.ago
  end

  def to_s
    [cc_code, txid, 'risk_level:' + risk_level, risk_msg, entity_name].join('; ')
  end

  def update_danger_transaction
    return if analyzed_user.nil?
    return if analysis_result.nil?
    analyzed_user.with_lock do
      if analysis_result.pass?
        analyzed_user.danger_transactions.where(txid: txid, cc_code: cc_code).destroy_all
      else
        analyzed_user.danger_transactions.find_or_create_by(txid: txid, cc_code: cc_code)
      end
    end
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

  def update_analyzed_user
    unless blockchain_tx
      Rails.logger.info("No blockhain_tx with #{txid} for TransactionAnalysis")
      return
    end
    user = blockchain_tx.user
    unless user
      Rails.logger.info("No user with #{txid} for TransactionAnalysis")
      return
    end
    self.analyzed_user = AnalyzedUser.find_or_create_by!(user_id: user.id)
  end
end
