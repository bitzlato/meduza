class PendingAnalysis < ApplicationRecord
  self.inheritance_column = nil

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
  validates :address_transaction, uniqueness: { scope: %i[source state cc_code] }, presence: true, on: :create, if: :pending?

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
