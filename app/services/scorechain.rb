require 'scorechain_client'

module Scorechain
  def logger
    @logger ||= Rails.logger.tagged(self)
  end
  module_function :logger

  def client
    @client ||= ScorechainClient.new(logger: logger)
  end
  module_function :client
end
