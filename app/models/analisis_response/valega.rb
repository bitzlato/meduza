module AnalisisResponse
  class Valega
    attr_reader :response

    delegate :error, :risk_msg, :report_url, :observations, to: :response, allow_nil: true

    def initialize(raw_response)
      @response = OpenStruct.new(raw_response)
    end

    def entity_name
      response.address_entity_name || response.transaction_entity_name
    end

    def entity_dir_name
      response.address_entity_dir_name || response.transaction_entity_dir_name
    end
  end
end
