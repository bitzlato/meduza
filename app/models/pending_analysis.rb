class PendingAnalysis < ApplicationRecord
  self.inheritance_column = nil

  scope :addresses, -> { where type: :address }
  scope :transactions, -> { where type: :transaction }

  include AASM
  belongs_to :analysis_result, optional: true

  before_validation if: :cc_code do
    self.cc_code = cc_code.upcase
  end

  validates :cc_code, presence: true
  validates :source, presence: true

  TYPES = %w[address transaction]
  validates :type, presence: true, inclusion: { in: TYPES }

  validates :address_transaction, presence: true
  validates :address_transaction, uniqueness: { scope: %i[source state cc_code reply_to correlation_id] }, presence: true, on: :create, if: :pending?

  delegate :risk_level, :risk_confidence, :entity_name, :entity_dir_name, to: :analysis_result, allow_nil: true

  aasm column: :state, whiny_transitions: true, requires_lock: true do
    state :pending, initial: true
    state :errored
    state :done
    state :skipped

    after_all_transitions :log_status_change

    event :done do
      transitions from: :pending, to: :done, guard: :analysis_result_id?
    end

    event :skip do
      transitions from: :pending, to: :skipped
    end

    event :pend do
      transitions from: :skipped, to: :pend
    end

    event :error do
      transitions from: :pending, to: :errored
    end
  end

  def callback?
    correlation_id? && reply_to?
  end

  def self.sources
    PendingAnalysis.group(:source).count.keys
  end

  def to_s
    address_transaction
  end

  def address?
    type == 'address'
  end

  def transaction?
    type == 'transaction'
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
