# Kiribori Template for Redis store
context = <<EOM
  * キャッシュストアとしてRedisを設定
  * セッションストアとしてキャッシュストアを設定
EOM

## Add gems

gem 'redis'
gem 'hiredis'

bundle_command 'install --quiet'


## Configuration for docker-compose

append_to_file 'docker-compose.development.yml', <<CODE

  redis:
    image: redis
    ports:
      - "6379:6379"
CODE

append_to_file '.env', <<EOT
REDIS_URL_FOR_CACHE=redis://127.0.0.1:6379/1
REDIS_URL=redis://127.0.0.1:6379/2
EOT

append_to_file '.env.example', <<EOT
REDIS_URL_FOR_CACHE=redis://127.0.0.1:6379/1
REDIS_URL=redis://127.0.0.1:6379/2
EOT

gsub_file 'config/environments/production.rb', /^\s+(?:#\s*)?config.cache_store\s+=\s+.*$/, <<'CODE'.rstrip
  config.cache_store = :redis_cache_store, { url: ENV['REDIS_URL_FOR_CACHE'] }
  config.session_store :cache_store
CODE

git add: %w[
  Gemfile
  Gemfile.lock
  .env.example
  docker-compose.development.yml
  config/environments/production.rb
].join(' ')

git commit: "-m 'Apply pundit template by Kiribori.\n#{context}'"
