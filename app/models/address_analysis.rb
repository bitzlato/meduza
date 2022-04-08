class AddressAnalysis < ApplicationRecord
  ACTUAL_PERIOD = 15.minutes

  belongs_to :analysis_result

  validates :cc_code, presence: true
  validates :address, uniqueness: { scope: :cc_code }, presence: true

  upsert_keys [:address, :cc_code]

  delegate :entity_name, :entity_dir_name, to: :analysis_result, allow_nil: true

  before_save do
    self.risk_level = analysis_result.try(:risk_level)
    self.risk_confidence = analysis_result.try(:risk_confidence)
  end

  def self.actual?(address)
    find_by(address: address).try &:actual?
  end

  def actual?
    updated_at > ACTUAL_PERIOD.ago
  end

  def analysis_results
    AnalysisResult.where(cc_code: cc_code, address_transaction: address)
  end

  def pending_analysis
    PendingAnalysis.where(cc_code: cc_code, address_transaction: address)
  end

  def recheck!
    payload = {
      address: address,
      cc_code: cc_code,
      source:  'AddressAnalysis',
      force: true,
      meta: { sent_at: Time.zone.now }
    }
    AMQP::Queue.publish :meduza, payload, routing_key: AMQP::Config.binding(:address_pender).fetch(:routing_key)
  end
end
