module RpcCallbacker
  def self.perform(payload, properties)
    Rails.logger.info "[RpcCallbacker] perform with payload #{payload} and properties #{properties}"
    AMQP::Queue.publish :meduza, payload, properties
  end
end
