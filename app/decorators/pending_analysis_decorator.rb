class PendingAnalysisDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id created_at address_transaction cc_code state source reply_to correlation_id risk_level risk_confidence analysis_result_message]
  end
end
