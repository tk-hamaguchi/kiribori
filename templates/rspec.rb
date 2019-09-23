# Kiribori Template for RSpec
context = <<EOM
  * ユニットテスト・インテグレーションテスト用ツールとしてRSpecを導入
EOM


## Add gems

gem_group :development, :test do
  gem 'rspec-rails', '~> 3.8'
  gem 'rails-controller-testing', require: false
  gem 'rspec-its'
  gem 'rspec_junit_formatter'
  gem 'shoulda-matchers', require: false
end

bundle_command 'install --quiet'


## Configuration for RSpec

generate 'rspec:install'

gsub_file 'spec/rails_helper.rb', /^# (Dir\[.+support.*)$/, '\1'

empty_directory 'spec/support'
create_file 'spec/support/rspec-its.rb', "require 'rspec/its'"

create_file 'spec/support/shoulda-matchers.rb',<<'EOS'
require 'shoulda/matchers'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
EOS

bundle_command 'exec rubocop -c .rubocop.yml -D --auto-correct'

git add: %w[
  Gemfile
  Gemfile.lock
  .rspec
  spec/rails_helper.rb
  spec/spec_helper.rb
  spec/support/rspec-its.rb
  spec/support/shoulda-matchers.rb
].join(' ')

git commit: "-m 'Apply rspec template by Kiribori.\n#{context}'"
