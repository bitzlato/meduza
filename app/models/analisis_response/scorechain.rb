module AnalisisResponse
  class Scorechain
    attr_reader :response

    def initialize(raw_response)
      @response = raw_response
    end

    def report_url; end
    def observations; end
    def error; end

    def risk_msg
      msg = []
      msg << "ASSIGNED: #{assigned_severity}(score: #{assigned_score})" if assigned&.dig('hasResult')
      msg << "INCOMING: #{incoming_severity}(score: #{incoming_score})" if incoming&.dig('hasResult')
      msg.join("\n")
    end

    def entity_name
      entity&.dig('name') || incommin_risk&.dig('name') || incoming_detail&.dig('name')
    end

    def entity_dir_name
      entity&.dig('type') || incommin_risk&.dig('type') || incoming_detail&.dig('type')
    end

    private

    def entity
      assigned.dig('result', 'details', 'entity')
    end

    def assigned
      response.dig('analysis', 'assigned')
    end

    def incommin_risk
      response.dig('analysis', 'incoming', 'result', 'risks', 0, 'causes', 0)
    end

    def incoming_detail
      incoming&.dig('result', 'details')&.min { |a, b| a['score'] <=> b['score'] }
    end

    def incoming
      response.dig('analysis', 'incoming')
    end

    def assigned_severity
      assigned.dig('result', 'severity')
    end

    def assigned_score
      assigned.dig('result', 'score')
    end

    def incoming_severity
      incoming.dig('result', 'severity')
    end

    def incoming_score
      incoming.dig('result', 'score')
    end

  end
end
