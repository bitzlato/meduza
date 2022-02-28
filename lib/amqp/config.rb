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

      def binding_exchange_id(id)
        binding(id).fetch(:exchange)
      end

      def binding_exchange(id)
        eid = binding_exchange_id(id)
        eid && exchange(eid)
      end

      def binding_queue(id)
        queue binding(id).fetch(:queue)
      end

      def binding_worker(id, args = [])
        ::AMQP.const_get(id.to_s.camelize).new(*args)
      end

      def routing_key(id)
        binding_queue(id).first
      end

      def topics(id)
        binding(id).fetch(:topics).split(',')
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
