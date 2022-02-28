class PendingAnalysis < ApplicationRecord
  self.inheritance_column = nil

  include AASM

  SOURCES = %w[p2p amqp]
  validates :source, presence: true, inclusion: { in: SOURCES }

  TYPES = %w[address transaction]
  validates :type, presence: true, inclusion: { in: TYPES }

  aasm column: :state, whiny_transitions: true, requires_lock: true do
    state :pending, initial: true
    state :errored
    state :done

    after_all_transitions :log_status_change

    event :done do
      transitions from: :pending, to: :done
      after do
        report_exception 'income/outcome transaction analysis', true, id: id if deposits.any? && withdrawals.any?
      end
    end

    event :error do
      transitions from: :pending, to: :errored
    end
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
