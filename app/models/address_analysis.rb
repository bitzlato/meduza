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

  before_create :update_analzyed_users

  after_save :update_danger_addresses

  def self.actual?(address)
    find_by(address: address).try &:actual?
  end

  def update_danger_addresses(force_users_update = false)
    return if analysis_result.nil?

    if force_users_update
      update_analzyed_users
      update_column :analyzed_user_ids, self.analyzed_user_ids
    end
    return if analyzed_user_ids.blank?
    AnalyzedUser.where(id: analyzed_user_ids).find_each do |analyzed_user|
      analyzed_user.with_lock do
        if analysis_result.pass?
          analyzed_user.danger_addresses.where(address: address, cc_code: cc_code).destroy_all
        else
          analyzed_user.danger_addresses.find_or_create_by(address: address, cc_code: cc_code)
        end
      end
    end
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

  private

  def update_analzyed_users
    self.analyzed_user_ids = Withdrawal.where(address: address, cc_code: cc_code).group(:user_id).count.keys
  end
end
