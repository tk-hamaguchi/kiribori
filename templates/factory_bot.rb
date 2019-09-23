# Kiribori Template for factory_bot
context = <<EOM
  * テストデータ生成用ツールとして `factory_bot` と `faker` を導入
EOM


## Add gems

gem_group :development, :test do
  gem 'factory_bot_rails'
  gem 'faker',             require: false
  gem 'faker-japanese',    require: false
end

bundle_command 'install --quiet'


## Configuration for FactoryBot

empty_directory 'spec/factories'
create_file 'spec/factories/faker.rb', <<'EOS'
require 'faker'

FactoryBot.define do
  sequence :user_email do |n|
    "#{Faker::Internet.username}#{n}@#{Faker::Internet.domain_name}"
  end
end
EOS

bundle_command 'exec rubocop -c .rubocop.yml -D --auto-correct --only "Style/FrozenStringLiteralComment"'


git add: %w[
  Gemfile
  Gemfile.lock
  spec/factories/faker.rb
].join(' ')

git commit: "-m 'Apply factory_bot template by Kiribori.\n#{context}'"
