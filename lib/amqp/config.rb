# encoding: UTF-8
# frozen_string_literal: true

module AMQP
  class Config
    class <<self
      def data
        @data ||= Hashie::Mash.new(
          YAML.safe_load(
            ERB.new(File.read(Rails.root.join('config', 'amqp.yml'))).result
          )
        )
      end

      def connect
        data[:connect]
      end

      def binding(id)
        data.
          fetch(:binding).
          fetch(id) || raise("No binding for #{id}")
      end

      def channel(id)
        (data[:channel] && data[:channel][id]) || {}
      end

      def queue(id)
        queue_settings = data.fetch(:queue).fetch(id)
        name = queue_settings.fetch(:name)
        settings = { durable: queue_settings.dig(:durable) }
        [name, settings]
      end

      def exchange(id)
        ex = data.fetch(:exchange).fetch(id)
        type = ex.fetch(:type)
        name = ex.fetch(:name)
        [type, name]
      end
    end
  end
end
