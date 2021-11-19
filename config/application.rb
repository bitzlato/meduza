require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Meduza
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    config.application = config_for(:application)
    config.autoload_paths += Dir[
      "#{config.root}/app/services",
      "#{config.root}/app/workers"
    ]

    config.time_zone = ENV.fetch('TIMEZONE', 'UTC')
    config.i18n.default_locale = ENV.fetch('RAILS_LOCALE', :en)

    config.active_record.schema_format = :sql
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.eager_load_paths += Dir[Rails.root.join('app')]
  end
end
