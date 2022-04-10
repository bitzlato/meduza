class ApplicationController < ActionController::Base
  layout 'fixed'

  helper_method :pending_queue_size

  private

  def pending_queue_size
    @pending_queue_size ||= PendingAnalysis.pending.count
  end
end
