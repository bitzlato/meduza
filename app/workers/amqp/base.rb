# frozen_string_literal: true

module AMQP
  class Base # rubocop:disable Lint/EmptyClass
    attr_reader :logger

    def initialize
      @logger = Rails.logger.tagged self.class.name
    end
  end
end
