# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module InfluxAdapter
  class << self
    def client
      @client ||= ::InfluxDB::Client.new config
    end

    def config
      yaml = ::Pathname.new('config/influxdb.yml')
      return {} unless yaml.exist?

      erb = ::ERB.new(yaml.read)
      ::SafeYAML.load(erb.result).fetch(Rails.env, {}).deep_symbolize_keys
    end
  end
end
