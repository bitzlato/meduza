class TransactionAnalysisDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[updated_at direction cc_code txid amount blockchain_tx risk_level risk_confidence analysis_result_message]
  end

  def blockchain_tx
    object.blockchain_tx.try(:id)
  end
end
