# syntax=docker/dockerfile:1

FROM ruby:2.7.4-slim-buster AS Builder

ARG RAILS_ENV=production

ENV RAILS_ENV=${RAILS_ENV} \
  APP_HOME=/home/app

RUN apt-get update -qq \
      && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends curl git make gcc libpq-dev g++ shared-mime-info tzdata vim xz-utils automake pkg-config libtool libffi-dev libssl-dev libgmp-dev python-dev gnupg gnupg2

WORKDIR $APP_HOME
COPY Gemfile Gemfile.lock $APP_HOME/

RUN gem update bundler --no-document
RUN if [ "$RAILS_ENV" = "production" ]; then bundle config set --local without 'development:test:deploy'; fi
RUN bundle config set --local system 'true' \
      && bundle install --jobs=$(nproc) \
      && bundle binstubs --all

FROM Builder AS App
# By default image is built using RAILS_ENV=production.
# You may want to customize it:
#
#   --build-arg RAILS_ENV=development
#
# See https://docs.docker.com/engine/reference/commandline/build/#set-build-time-variables-build-arg
#
ARG RAILS_ENV=production

# Devise requires secret key to be set during image build or it raises an error
# preventing from running any scripts.
# Users should override this variable by passing environment variable on container start.
ENV RAILS_ENV=${RAILS_ENV} \
  APP_HOME=/home/app

# Create group "app" and user "app".
RUN addgroup --gid 1000 --system app \
      && adduser --system --home ${APP_HOME} --shell /sbin/nologin --ingroup app --uid 1000 app

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
      && apt-get install -y nodejs
RUN apt-get update -qq && apt-get install -y build-essential yarn

WORKDIR $APP_HOME
COPY Gemfile Gemfile.lock $APP_HOME/

# Install dependencies
RUN if [ "$RAILS_ENV" = "production" ]; then bundle config set --local without 'development:test:deploy'; fi
RUN bundle config set --local system 'true' \
      && bundle install --jobs=$(nproc) \
      && bundle binstubs --all

RUN apt-get remove -yq git gcc g++ \
      && chown -R app:app $APP_HOME

USER app

# Copy the main application.
COPY --chown=app:app . $APP_HOME

RUN yarn install --check-files
RUN if [ "$RAILS_ENV" = "production" ]; then SECRET_KEY_BASE=secret SKIP_MANAGEMENT_API=true bundle exec rake assets:precompile; fi

# Expose port 3000 to the Docker host, so we can access it
# from the outside.
EXPOSE 3000

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
# COPY --chown=app:app config/docker/docker-entrypoint.sh /
# RUN chmod +x /docker-entrypoint.sh
# ENTRYPOINT ["/docker-entrypoint.sh"]
