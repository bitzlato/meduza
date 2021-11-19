# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

set :stage, :production

server ENV['PRODUCTION_HOST'],
       user: fetch(:user),
       roles: %w[app db bugsnag webpack].freeze,
       ssh_options: { forward_agent: true }
