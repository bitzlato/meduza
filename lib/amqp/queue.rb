# encoding: UTF-8
# frozen_string_literal: true

module AMQP
  class Queue

    class <<self
      def connection
        @connection ||= Bunny.new(AMQP::Config.connect).tap do |conn|
          conn.start
        end
      end

      def channel
        @channel ||= connection.create_channel
      end

      def exchanges
        @exchanges ||= {default: channel.default_exchange}
      end

      def exchange(id)
        exchanges[id] ||= channel.send(*AMQP::Config.exchange(id))
      end

      def publish(eid, payload, attrs={})
        payload = JSON.dump payload
        Rails.logger.info { { message: 'AMQP queue publish', payload: payload, eid: eid, attrs: attrs }}
        exchange(eid).publish(payload, attrs)
      end
    end
  end
end
