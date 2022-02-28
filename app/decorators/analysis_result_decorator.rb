class AnalysisResultDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id created_at cc_code address_transaction type risk_level risk_confidence raw_response]
  end

  def raw_response
    h.content_tag :code, object.raw_response.as_json
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
