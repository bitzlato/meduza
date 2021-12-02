class AnalyzedUserDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[user_id updated_at] + (1..3).map { |risk_level| "risk_level_#{risk_level}_count" } + %i[last_risked_transaction_analysis]
  end

  (1..3).each do |risk_level|
    method = "risk_level_#{risk_level}_count"
    define_method method do
      h.link_to object.send(method), h.transaction_analyses_path(q: { analyzed_user_id_eq: object.id, risk_level_eq: risk_level })
    end
  end

  def last_risked_transaction_analysis
    h.render 'transaction_analysis_brief', transaction_analysis: object.last_risked_transaction_analysis if object.last_risked_transaction_analysis
  end
end
