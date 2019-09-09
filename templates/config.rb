# Kiribori Template for Config
context = <<EOM
  * 各種設定情報を一元管理するために `config` を追加
EOM

gem 'config'

run_bundle
bundle_command 'exec spring stop'

generate 'config:install'

git add: %w[
  .gitignore
  Gemfile
  Gemfile.lock
  config/initializers/config.rb
  config/settings.yml
  config/settings/development.yml
  config/settings/production.yml
  config/settings/test.yml
].join(' ')

git commit: "-m 'Apply config template by Kiribori.\n#{context}'"
