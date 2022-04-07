# frozen_string_literal: true

module AMQP
  class Base # rubocop:disable Lint/EmptyClass
    attr_reader :logger

    def initialize
      @logger = Rails.logger
    end
  end
end
