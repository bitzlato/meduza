# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

lock '3.16'

require './lib/capistrano/deploy_branch'

set :user, 'meduza'
set :application, 'meduza'

set :roles, %w[sidekiq web app db].freeze

set :repo_url, ENV.fetch('DEPLOY_REPO_URL', `git remote -v | grep origin | head -1 | awk '{ print $2 }'`.chomp) if ENV['USE_LOCAL_REPO'].nil?

set :keep_releases, 10

set :linked_files, %w[.env config/master.key]
set :linked_dirs, %w[log node_modules tmp/pids tmp/cache tmp/sockets public/assets public/uploads public/uploads public/packs]

set :config_files, fetch(:linked_files)

set :deploy_to, -> { "/home/#{fetch(:user)}/#{fetch(:application)}" }

set :disallow_pushing, true

set :db_dump_extra_opts, '-n meduza -n public -t meduza.* -t public.blockchain_tx '

set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip

set :nvm_node, File.read('.nvmrc').strip
set :nvm_map_bins, %w[node npm yarn rake]

set :conditionally_migrate, true # Only attempt migration if db/migrate changed - not related to Webpacker, but a nice thing

set :assets_roles, [:webpack] # Give the webpack role to a single server
set :assets_prefix, 'packs' # Assets are located in /packs/
set :assets_manifests, lambda { # Tell Capistrano-Rails how to find the Webpacker manifests
  [release_path.join('public', fetch(:assets_prefix), 'manifest.json*')]
}

set :assets_dependencies,
    %w[
      app/assets lib/assets vendor/assets app/javascript app/assets/config/manifest.js
      yarn.lock Gemfile.lock config/routes.rb config/initializers/assets.rb
      .semver
    ]

set :conditionally_migrate, true # Only attempt migration if db/migrate changed - not related to Webpacker, but a nice thing

set :keep_assets, 2
set :local_assets_dir, 'public'

set :puma_init_active_record, true

set :db_local_clean, false
set :db_remote_clean, true

set :puma_control_app, true
set :puma_threads, [2, 4]
set :puma_tag, fetch(:application)
set :puma_daemonize, false
set :puma_preload_app, false
set :puma_prune_bundler, true
set :puma_init_active_record, true
set :puma_workers, 0
set :puma_start_task, 'systemd:puma:start'
set :puma_extra_settings, %{
 lowlevel_error_handler do |e|
   Bugsnag.notify(e) if defined? Bugsnag
   [500, {}, ["An error has occurred"]]
 end
}

set :init_system, :systemd

set :systemd_sidekiq_role, :sidekiq
set :systemd_sidekiq_instances, []

set :systemd_daemon_role, :daemons
set :systemd_daemon_instances, [:income_transactions_analyser]

set :app_version, SemVer.find.to_s

# after 'deploy:check', 'master_key:check'
after 'deploy:publishing', 'systemd:puma:reload-or-restart'
after 'deploy:publishing', 'systemd:daemon:reload-or-restart'

Rake::Task['deploy:assets:backup_manifest'].clear_actions

set :current_version, `git rev-parse HEAD`.strip
