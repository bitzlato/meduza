require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  default_url_options Rails.configuration.application.fetch(:default_url_options).symbolize_keys if Rails.configuration.application.try(:key?, :default_url_options)

  mount Sidekiq::Web => '/sidekiq'
  root to: 'dashboard#index'

  resources :address_analyses, only: [:index, :show]
  resources :transaction_analyses, only: [:index, :show]
  resources :analyzed_users, only: [:index, :show]
  resources :analysis_results, only: [:index, :show]
end
