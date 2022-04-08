class AddressAnalysisDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id address cc_code risk_level risk_confidence analysis_result_message created_at updated_at]
  end
end
