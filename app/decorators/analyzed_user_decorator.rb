class AnalyzedUserDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[user_id updated_at danger_transactions_count danger_addresses_count]
  end

  def danger_transactions_count
    h.link_to object.danger_transactions_count,
      h.danger_transactions_path(q: { analyzed_user_id_eq: object.id } )
  end

  def danger_transactions_count_fake
    h.link_to object.danger_transactions_count,
      h.transaction_analyses_path(q: { analyzed_user_id_eq: object.id,
                                       risk_level_eq: ValegaAnalyzer::DANGER_RISK_LEVEL,
                                       risk_confidence_eq: ValegaAnalyzer::DANGER_RISK_CONFIDENCE })
  end

  def last_risked_transaction_analysis
    h.render 'transaction_analysis_brief', transaction_analysis: object.last_risked_transaction_analysis if object.last_risked_transaction_analysis
  end
end
