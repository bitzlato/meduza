class AnalyzedUserDecorator < ApplicationDecorator
  delegate_all

  %i[risk_level_1_count risk_level_2_count risk_level_3_count].each do |method|
    define_method method do
      h.link_to object.send(method), h.transaction_analyses_path(q: { analyzed_user_id_eq: object.id })
    end
  end
end
