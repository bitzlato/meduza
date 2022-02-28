class TransactionAnalysisDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[updated_at direction cc_code txid amount blockchain_tx analysis_result risk_level risk_confidence]
  end

  def blockchain_tx
    object.blockchain_tx.try(:id)
  end

  def analysis_result
    return '-' if object.analysis_result.nil?
    h.link_to 'link', h.analysis_result_path(object.analysis_result)
  end
end
