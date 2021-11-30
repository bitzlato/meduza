class TransactionAnalysisDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[updated_at cc_code txid amount input_addresses blockchain_tx analyzed_user user_id analysis_result risk_level risk_confidence]
  end

  def blockchain_tx
    object.blockchain_tx_id
  end

  def analyzed_user
    h.link_to object.analyzed_user_id, h.analyzed_user_path(object.analyzed_user)
  end

  def analysis_result
    h.content_tag :code, object.analysis_result.as_json
  end
end
