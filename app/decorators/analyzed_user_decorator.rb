class AnalyzedUserDecorator < ApplicationDecorator
  delegate_all

  (1..3).each do |risk_level|
    method = "risk_level_#{risk_level}_count"
    define_method method do
      h.link_to object.send(method), h.transaction_analyses_path(q: { analyzed_user_id_eq: object.id, risk_level_eq: risk_level })
    end
  end
end
