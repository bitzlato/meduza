require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  if Rails.configuration.application.key? :default_url_options
    default_url_options Rails.configuration.application.fetch(:default_url_options).symbolize_keys
  end

  mount Sidekiq::Web => '/sidekiq'
end
