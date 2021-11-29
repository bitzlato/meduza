class TransactionAnalysis < ApplicationRecord
  belongs_to :analysis_result, optional: true
  belongs_to :analyzed_user, optional: true
  belongs_to :blockchain_tx

  has_one :deposit, through: :blockchain_tx
  has_one :user, through: :deposit

  counter_culture :analyzed_user,
    column_name: proc {|model| model.analyzed_user_id.present? && model.risk_confidence == 1.0 ? "risk_level_#{model.risk_level}_count" : nil },
    column_names: {
      TransactionAnalysis.where(risk_level: 1) => :risk_level_1_count,
      TransactionAnalysis.where(risk_level: 2) => :risk_level_2_count,
      TransactionAnalysis.where(risk_level: 3) => :risk_level_3_count,
    },
    touch: true

  scope :include_address, ->(address) { where("input_addresses::jsonb ? :address", address: address) }

  validates :input_addresses, presence: true, unless: :analysis_result

  before_create :set_analyzed_user

  def self.actual?(txid)
    ta = find_by(txid: txid)
    return false if ta.nil?

    ta.updated_at > 1.week.ago
  end

  private

  def set_analyzed_user
    self.analyzed_user ||= AnalyzedUser.find_or_create_by!(user: user) if user.present?
  end
end
