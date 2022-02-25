class TransactionAnalysis < ApplicationRecord
  include AASM

  upsert_keys [:txid]

  belongs_to :analysis_result, optional: true

  belongs_to :blockchain_tx, primary_key: :txid, foreign_key: :txid, optional: true
  has_many :deposits, through: :blockchain_tx
  has_many :withdrawals, through: :blockchain_tx
  has_many :deposit_users, through: :deposits, class_name: 'User'
  has_many :withdrawals_users, through: :withdrawals, class_name: 'User'

  #counter_culture :analyzed_user,
    #column_name: proc {|model| model.analyzed_user_id.present? && model.risk_confidence == 1.0 ? "risk_level_#{model.risk_level}_count" : nil },
    #column_names: {
      #TransactionAnalysis.where(risk_level: 1) => :risk_level_1_count,
      #TransactionAnalysis.where(risk_level: 2) => :risk_level_2_count,
      #TransactionAnalysis.where(risk_level: 3) => :risk_level_3_count,
    #},
    #touch: true

  scope :pending, -> { where state: :pending }

  delegate :amount, to: :blockchain_tx, allow_nil: true
  delegate :risk_msg, :transaction_entity_name, to: :analysis_result

  SOURCES = %w[p2p amqp]
  validates :source, presence: true, inclusion: { in: SOURCES }

  DIRECTIONS = %w[income outcome unknown internal]
  validates :direction, inclusion: { in: DIRECTIONS }, if: :direction?

  aasm column: :state, whiny_transitions: true, requires_lock: true do
    state :pending, initial: true
    state :errored
    state :done

    after_all_transitions :log_status_change

    event :done do
      transitions from: :pending, to: :done
      after do
        report_exception 'income/outcome transaction analysis', true, id: id if deposits.any? && withdrawals.any?
        update! direction: 'income' if deposits.any?
        update! direction: 'outcome' if withdrawals.any?
      end
      # after :set_analyzed_users
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

  private

  def log_record!(record)
    record = record.merge from_state: aasm.from_state, to_state: aasm.to_state, event: aasm.current_event, at: Time.zone.now.iso8601
    Rails.logger.info "TransactionAnalysis##{id} log record #{record}"
  end

  def log_status_change
    Rails.logger.info "TransactionAnalysis##{id} changing from #{aasm.from_state} to #{aasm.to_state} (event: #{aasm.current_event})"
    log_record! from_state: aasm.from_state, to_state: aasm.to_state, event: aasm.current_event, at: Time.zone.now.iso8601
  end
end
