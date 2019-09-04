# frozen_string_literal: true

def source_paths
  [Rails.root]
end

gem_group :development, :test do
  gem 'rspec-rails', '~> 3.8'
  gem 'rails-controller-testing', require: false
  gem 'rspec-its'
  gem 'rspec_junit_formatter'
end

run 'bundle install'

generate 'rspec:install'

gsub_file 'spec/rails_helper.rb', /^# \(Dir\[.\+'support'.\+\)$/, '\1'

empty_directory 'spec/support'
create_file 'spec/support/rspec-its.rb', "require 'rspec/its'"
