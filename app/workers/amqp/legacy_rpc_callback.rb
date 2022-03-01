module AMQP
  class LegacyRpcCallback
    def process(payload, metadata)
      Rails.logger.info "[LegacyRpcCallback] payload=#{payload}, metadata=#{metadata}"
    end
  end
end
