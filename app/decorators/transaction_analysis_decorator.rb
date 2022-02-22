class TransactionAnalysisDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[updated_at cc_code txid amount blockchain_tx analyzed_user user_id analysis_result risk_level risk_confidence]
  end

  def blockchain_tx
    object.blockchain_tx_id
  end

  def analyzed_user
    return '-' if object.analyzed_user.nil?
    h.link_to 'link', h.analyzed_user_path(object.analyzed_user)
  end

  def analysis_result
    return '-' if object.analysis_result.nil?
    h.link_to 'link', h.analysis_result_path(object.analysis_result)
  end
end
