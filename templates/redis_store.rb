# Kiribori Template for Redis store
context = <<EOM
  * セッションストアとしてRedisを設定
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
REDIS_URL=redis://127.0.0.1:6379/1
EOT

append_to_file '.env.example', <<EOT
REDIS_URL=redis://127.0.0.1:6379/1
EOT

create_file 'config/initializers/session_store.rb', <<'CODE'.strip
Rails.application.config.session_store(
  :cache_store,
  {
    cache:        ActiveSupport::Cache.lookup_store(
                    :redis_cache_store,
                    {
                      url:           ENV['REDIS_URL'],  
                      error_handler: -> (method:, returning:, exception:) {
                        Raven.capture_exception(
                          exception,
                          level: 'warning',
                          tags:  { method: method, returning: returning }
                        )
                      }
                    }
                  ),
    expire_after: 24 * 60 * 60,
    secure:       Rails.env.production?
  }
)
CODE

git add: %w[
  Gemfile
  Gemfile.lock
  .env.example
  docker-compose.development.yml
  config/initializers/session_store.rb
].join(' ')

git commit: "-m 'Apply redis_store template by Kiribori.\n#{context}'"
