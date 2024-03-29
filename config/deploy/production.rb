# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

set :stage, :production
set :puma_bind, %w[tcp://172.31.0.6:9701]

server ENV['PRODUCTION_HOST'],
       user: fetch(:user),
       roles: %w[app db bugsnag webpack daemons amqp_daemons sidekiq].freeze,
       ssh_options: { forward_agent: true }
