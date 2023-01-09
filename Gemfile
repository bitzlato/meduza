source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version')

gem 'dotenv-rails'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.4', '>= 6.1.4.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.7.1'
# gem 'bcrypt', '~> 3.1.7'

gem 'env-tweaks', '~> 1.0.0'
gem 'rails-i18n', '~> 6.0'
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false
gem 'sidekiq', '~> 6.5.8'
gem 'active_link_to'
gem 'enumerize'
gem 'kaminari'
gem 'sass-rails', '>= 6'
gem 'sidekiq-cron'
gem 'simple_form'
gem 'slim-rails'

gem 'yabeda'
gem 'yabeda-prometheus'
gem 'yabeda-rails'
gem 'yabeda-http_requests'

gem 'counter_culture', '~> 2.0'

gem 'faraday'
gem 'faraday_curl', '~> 0.0.2'
gem 'faraday-detailed_logger', '~> 2.3'
gem 'active_record_upsert'
gem 'ransack', github: 'activerecord-hackery/ransack'

gem 'caxlsx', '~> 3.0'
gem 'caxlsx_rails'

group :development, :test do
  gem 'brakeman'
  gem 'bundler-audit'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry'
  gem 'pry-byebug', '~> 3.9.0'
  gem 'pry-rails'
end

group :development do
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'guard'
  gem 'guard-minitest'
  gem 'guard-rubocop'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'

  gem "minitest-stub_any_instance"
  gem "webmock"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'sd_notify'
gem 'semver2', '~> 3.4'
gem 'bugsnag'

gem 'strip_attributes'

group :deploy do
  gem 'bugsnag-capistrano', require: false
  gem 'capistrano', require: false
  gem 'capistrano3-puma'
  gem 'capistrano-bundler', require: false
  gem 'capistrano-db-tasks', require: false, github: 'brandymint/capistrano-db-tasks', branch: 'feature/extra_args_for_dump'
  gem 'capistrano-dotenv-tasks'
  gem 'capistrano-faster-assets', require: false
  gem 'capistrano-git-with-submodules'
  gem 'capistrano-master-key', require: false, github: 'virgoproz/capistrano-master-key'
  gem 'capistrano-nvm', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rails-console', require: false
  gem 'capistrano-rbenv', require: false
  gem 'capistrano-shell', require: false
  gem 'capistrano-systemd-multiservice', github: 'brandymint/capistrano-systemd-multiservice', require: false
  gem 'capistrano-yarn', require: false
end

gem 'money', '~> 6.16'

gem "redis-namespace", "~> 1.8"

gem "draper", "~> 4.0"

gem "bunny", "~> 2.19"

gem "aasm", "~> 5.2"

gem "after_commit_everywhere", "~> 1.1"

gem "hashie", "~> 5.0"

gem 'jwt', '~> 2.3.0'

gem "flipper", "~> 0.24.0"

gem "flipper-active_record", "~> 0.24.0"

gem "flipper-ui", "~> 0.24.0"

gem "rails-ujs", "~> 0.1.0"

gem "slack-notifier", "~> 2.4"
