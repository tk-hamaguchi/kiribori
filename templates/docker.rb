# Kiribori Template for docker
context = <<EOM
  * コンテナ化のためにDockerfileを作成
EOM

copy_file '.gitignore', '.dockerignore'

create_file 'Dockerfile', <<'CODE'
FROM ruby:2.6.5-buster

ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY ${RAILS_MASTER_KEY}

ENV APP_ROOT /var/rails
ENV TZ JST-9
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NOWARNINGS yes
ENV RAILS_LOG_TO_STDOUT true
ENV PORT 3000
ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV DATABASE_URL mysql2://root:mysql123@db/rails_app?reconnect=true&prepared_statements=true&encoding=utf8mb4

RUN apt-get update -qq && \
    apt-get install -y apt-transport-https apt-utils && \
    apt-get dist-upgrade -qq

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install -qq -y yarn nodejs

RUN apt-get clean -qq && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN gem install bundler --no-document

WORKDIR $APP_ROOT
COPY Gemfile Gemfile.lock package.json yarn.lock $APP_ROOT/

RUN bundle install --deployment --without development test

RUN yarn install

ADD . $APP_ROOT

RUN bundle exec rake assets:precompile

EXPOSE $PORT

CMD bundle exec rails s -p $PORT -b 0.0.0.0 -e $RAILS_ENV

# HEALTHCHECK CMD curl -s -S http://${HOSTNAME}:3000/healthz
CODE


create_file 'Dockerfile.alpine', <<'CODE'
FROM ruby:2.6.5-alpine3.10

ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY ${RAILS_MASTER_KEY}

ENV APP_ROOT /var/rails
ENV TZ JST-9
ENV RAILS_LOG_TO_STDOUT true
ENV PORT 3000
ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV DATABASE_URL mysql2://root:mysql123@db/rails_app?reconnect=true&prepared_statements=true&encoding=utf8mb4

RUN apk update
RUN apk add --no-cache --update \
    alpine-sdk nodejs-current nodejs-npm yarn mysql-client mysql-dev python2 tzdata curl

RUN gem install bundler --no-document

WORKDIR $APP_ROOT
COPY Gemfile Gemfile.lock package.json yarn.lock $APP_ROOT/

RUN bundle install --deployment --without development test

RUN yarn install

ADD . $APP_ROOT

RUN bundle exec rake assets:precompile

EXPOSE $PORT

CMD bundle exec rails s -p $PORT -b 0.0.0.0 -e $RAILS_ENV

# HEALTHCHECK CMD curl -s -S http://${HOSTNAME}:3000/healthz
CODE


create_file 'Dockerfile.slim', <<'CODE'
FROM ruby:2.6.5-slim-buster

ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY ${RAILS_MASTER_KEY}

ENV APP_ROOT /var/rails
ENV TZ JST-9
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NOWARNINGS yes
ENV RAILS_LOG_TO_STDOUT true
ENV PORT 3000
ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV DATABASE_URL mysql2://root:mysql123@db/rails_app?reconnect=true&prepared_statements=true&encoding=utf8mb4

RUN apt-get update -qq && \
    apt-get install -qq -y apt-transport-https apt-utils curl gnupg2 gcc g++ make patch git default-libmysqlclient-dev && \
    apt-get dist-upgrade -qq

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install -qq -y yarn nodejs

RUN apt-get clean -qq && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN gem install bundler --no-document

WORKDIR $APP_ROOT
COPY Gemfile Gemfile.lock package.json yarn.lock $APP_ROOT/

RUN bundle install --deployment --without development test

RUN yarn install

ADD . $APP_ROOT

RUN bundle exec rake assets:precompile

EXPOSE $PORT

CMD bundle exec rails s -p $PORT -b 0.0.0.0 -e $RAILS_ENV

# HEALTHCHECK CMD curl -s -S http://${HOSTNAME}:3000/healthz
CODE

copy_file 'docker-compose.development.yml', 'docker-compose.yml'

insert_into_file 'docker-compose.yml', <<EOT, after: /^services:$/

  app:
    build:
      context: .
      #dockerfile: Dockerfile.alpine
      #dockerfile: Dockerfile.slim
      args:
        RAILS_MASTER_KEY: $RAILS_MASTER_KEY
    ports:
      - 3000:3000
    depends_on:
      - db
      - redis
    environment:
      DATABASE_URL:        mysql2://root:mysql123@db:3306/#{app_name}?encoding=utf8mb4&prepared_statements=true
      REDIS_URL:           redis://redis:6379/1
    tmpfs:
      - /var/rails/tmp
EOT

append_to_file '.env', <<EOT
RAILS_MASTER_KEY=#{File.read('config/master.key')}
EOT

append_to_file '.env.example', <<EOT
RAILS_MASTER_KEY=
EOT

git add: %w[
  Dockerfile
  Dockerfile.slim
  Dockerfile.alpine
  .dockerignore
  .env.example
  docker-compose.yml
].join(' ')

git commit: "-m 'Apply docker template by Kiribori.\n#{context}'"
