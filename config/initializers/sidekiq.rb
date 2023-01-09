# frozen_string_literal: true

require 'sidekiq'
Sidekiq.default_job_options = { 'backtrace' => true }

url = ENV.fetch('SIDEKIQ_REDIS_URL', ENV.fetch('REDIS_URL', 'redis://localhost:6379/7/meduza_sidekiq'))

if Rails.env.test?
  require 'sidekiq/testing/inline'
  Sidekiq::Testing.fake!
else
  Sidekiq.logger = ActiveSupport::Logger.new Rails.root.join './log/sidekiq.log'
  Sidekiq.configure_server do |config|
    config.redis = { url: url }
    Sidekiq.logger.info "Configure server for application #{AppVersion}"
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: url }
    Sidekiq.logger.info "Configure server for application #{AppVersion}"
  end
end
