class PendingAnalysisDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id created_at address_transaction cc_code state type source reply_to correlation_id meta risk_level risk_confidence analysis_result_message]
  end

  def state
    h.pending_state object.state
  end
end
