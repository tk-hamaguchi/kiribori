# frozen_string_literal: true

require 'bundler/setup'
require 'simplecov'
require 'codecov'

require 'kiribori'

if ENV['COVERAGE'] || ENV['CI'] || ENV['CODECOV_TOKEN']
  SimpleCov.start do
    add_filter 'features'
    add_filter 'spec'
  end
  SimpleCov.command_name 'RSpec'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov if ENV['CODECOV_TOKEN']
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
