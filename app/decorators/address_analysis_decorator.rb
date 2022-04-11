class AddressAnalysisDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id address cc_code risk_level risk_confidence entity_name entity_dir_name analysis_result_message created_at updated_at]
  end

  def address
    return h.middot if object.address.nil?

    h.link_to h.address_analysis_path(object.id) do
      h.present_address object.address
    end
  end
end
