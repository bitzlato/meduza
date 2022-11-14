FROM ruby:2.7.4-bullseye

# By default image is built using RAILS_ENV=production.
# You may want to customize it:
#
#   --build-arg RAILS_ENV=development
#
# See https://docs.docker.com/engine/reference/commandline/build/#set-build-time-variables-build-arg
#
ARG RAILS_ENV=production
ENV RAILS_ENV=${RAILS_ENV} APP_HOME=/home/app

# Allow customization of user ID and group ID (it's useful when you use Docker bind mounts)
ARG UID=1000
ARG GID=1000

# Set the TZ variable to avoid perpetual system calls to stat(/etc/localtime)
ENV TZ=UTC

# Create group "app" and user "app".
RUN groupadd -r --gid ${GID} app \
  && useradd --system --create-home --home ${APP_HOME} --shell /sbin/nologin --no-log-init \
  --gid ${GID} --uid ${UID} app

# install nodejs && yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
      && apt-get install -y nodejs
RUN apt-get update -qq && apt-get install -y build-essential yarn

WORKDIR $APP_HOME

COPY --chown=app:app yarn.lock $APP_HOME/
RUN yarn install --check-files

# Upgrade RubyGems and install the latest Bundler version
RUN gem update --system && \
    gem install bundler

# Install dependencies defined in Gemfile.
COPY --chown=app:app Gemfile Gemfile.lock .ruby-version $APP_HOME/
RUN mkdir -p /opt/vendor/bundle \
  && chown -R app:app /opt/vendor $APP_HOME \
  && su app -s /bin/bash -c "bundle config --local deployment 'true'" \
  && su app -s /bin/bash -c "bundle config --local path '/opt/vendor/bundle'" \
  && su app -s /bin/bash -c "bundle config --local without 'development test'" \
  && su app -s /bin/bash -c "bundle config --local clean 'true'" \
  && su app -s /bin/bash -c "bundle config --local no-cache 'true'" \
  && su app -s /bin/bash -c "bundle install --jobs=4"

# Copy application sources.
COPY --chown=app:app . $APP_HOME

# Switch to application user.
USER app

# Initialize application configuration & assets.
# RUN chmod +x ./bin/logger
RUN bundle exec rake tmp:create

RUN ls -la config

RUN SECRET_KEY_BASE=secret bundle exec rake assets:precompile

# Expose port 3000 to the Docker host, so we can access it from the outside.
EXPOSE 3000

# The main command to run when the container starts.
CMD ["bundle", "exec", "puma", "--config", "config/puma.rb"]
