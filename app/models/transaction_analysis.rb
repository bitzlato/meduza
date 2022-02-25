class TransactionAnalysis < ApplicationRecord
  include AASM

  belongs_to :analysis_result, optional: true
  belongs_to :analyzed_user, optional: true

  belongs_to :blockchain_tx, primary_key: :txid, foreign_key: :txid
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

  delegate :amount, to: :blockchain_tx, allow_nil: true
  delegate :risk_msg, :transaction_entity_name, to: :analysis_result

  SOURCES = %w[p2p amqp]
  validates :sources, presence: true, inclusion: { in: SOURCES }

  aasm column: :state, whiny_transitions: true, requires_lock: true do
    state :pending, initial: true
    state :errored
    state :done

    after_all_transitions :log_status_change

    event :done do
      transitions from: :pending, to: :checked, guard: :analysis_result?
    end

    event :error do
      transitions from: :pending, to: :errored
    end
  end

  def self.actual?(txid)
    ta = find_by(txid: txid)
    return false if ta.nil?

    ta.updated_at > 1.week.ago
  end

  def to_s
    [cc_code, txid, 'risk_level:' + risk_level, risk_msg, transaction_entity_name].join('; ')
  end

  def user_id
    user.try(:id)
  end

  private

  def log_status_change
    Rails.logger.info "Transfer##{id} changing from #{aasm.from_state} to #{aasm.to_state} (event: #{aasm.current_event})"
    log_record!(from_state: aasm.from_state, to_state: aasm.to_state, event: aasm.current_event, at: Time.zone.now.iso8601)
  end

  def set_analyzed_user
    self.analyzed_user ||= AnalyzedUser.find_or_create_by!(user: user) if user.present?
  end
end
