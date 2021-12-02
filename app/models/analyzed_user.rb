class AnalyzedUser < ApplicationRecord
  belongs_to :user
  upsert_keys [:user_id]

  has_many :transaction_analyses

  def last_risked_transaction_analysis
    @last_risked_transaction_analysis ||= transaction_analyses.where(risk_level: 3, risk_confidence: 1.0).last
  end

  def to_s
    'user_id:' + user_id.to_s
  end
end
